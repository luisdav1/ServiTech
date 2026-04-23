# ServiTech — Sistema de Gestión de Reparaciones

Aplicación web desarrollada en **ASP.NET WebForms (.NET Framework 4.6.1)** para la gestión del histórico de reparaciones de un servicio técnico de electrodomésticos.

---

## Tabla de contenidos

- [Descripción](#descripción)
- [Tecnologías](#tecnologías)
- [Requisitos previos](#requisitos-previos)
- [Configuración de la base de datos](#configuración-de-la-base-de-datos)
- [Configuración de la aplicación](#configuración-de-la-aplicación)
- [Estructura del proyecto](#estructura-del-proyecto)
- [Módulos y funcionalidades](#módulos-y-funcionalidades)
- [Modelo de datos](#modelo-de-datos)
- [Capa de lógica de negocio](#capa-de-lógica-de-negocio)
- [Validaciones](#validaciones)

---

## Descripción

ServiTech permite registrar y consultar el historial completo de reparaciones de electrodomésticos, gestionando las entidades relacionadas: técnicos, clientes y equipos. Ofrece un dashboard con estadísticas en tiempo real, formularios con validación del lado del servidor y un histórico filtrable con paginación.

---

## Tecnologías

| Componente        | Tecnología                          |
|-------------------|-------------------------------------|
| Backend           | ASP.NET WebForms, C# (.NET 4.6.1)  |
| Base de datos     | SQL Server Express                  |
| Acceso a datos    | ADO.NET (`SqlConnection`, `SqlCommand`) |
| UI / Estilos      | Bootstrap 3.3.7, Glyphicons        |
| Scripts cliente   | jQuery 3.3.1                        |
| Servidor web      | IIS Express                         |

---

## Requisitos previos

- Visual Studio 2017 o superior
- SQL Server Express (cualquier versión reciente)
- .NET Framework 4.6.1
- NuGet (para restaurar paquetes)

---

## Configuración de la base de datos

**1. Ejecutar el script de creación**

Abrir SQL Server Management Studio (SSMS) y ejecutar el archivo:

```
WebApplication1/App_Data/CrearTablas.sql
```

Este script:
- Crea la base de datos `GestionReparaciones` si no existe.
- Crea las cuatro tablas con sus restricciones de clave foránea.
- Inserta datos de ejemplo para pruebas iniciales.

**2. Si la base de datos ya existía con la columna `Telefono`**

Ejecutar el siguiente script de migración en SSMS:

```sql
USE GestionReparaciones;
EXEC sp_rename 'Tecnicos.Telefono', 'Celular', 'COLUMN';
EXEC sp_rename 'Clientes.Telefono', 'Celular', 'COLUMN';
```

---

## Configuración de la aplicación

La cadena de conexión se encuentra en `WebApplication1/Web.config`:

```xml
<connectionStrings>
    <add name="CadenaReparaciones"
         connectionString="Server=NOMBRE_SERVIDOR\SQLEXPRESS;Database=GestionReparaciones;Integrated Security=True;TrustServerCertificate=True;"
         providerName="System.Data.SqlClient" />
</connectionStrings>
```

Reemplazar `NOMBRE_SERVIDOR` con el nombre del equipo donde corre SQL Server Express.

Para encontrar el nombre del servidor, ejecutar en SSMS:
```sql
SELECT @@SERVERNAME;
```

---

## Estructura del proyecto

```
WebApplication1/
│
├── App_Data/
│   └── CrearTablas.sql          # Script de creación de BD y datos de ejemplo
│
├── Models/                      # Capa de lógica y acceso a datos
│   ├── Tecnico.cs
│   ├── Cliente.cs
│   ├── Electrodomestico.cs
│   └── Reparacion.cs
│
├── Content/                     # Hojas de estilo (Bootstrap + Site.css)
├── Scripts/                     # jQuery, Bootstrap JS
│
├── Site.Master                  # Master Page principal (Bootstrap navbar)
├── Default.aspx                 # Dashboard con estadísticas
├── GestionDatos.aspx            # ABM de Técnicos, Clientes y Electrodomésticos
├── RegistroReparacion.aspx      # Formulario de nueva reparación
├── Historico.aspx               # Histórico filtrable con paginación
│
└── Web.config                   # Configuración: cadena de conexión, globalization
```

---

## Módulos y funcionalidades

### Dashboard (`Default.aspx`)
- Tarjetas con totales: técnicos, clientes, electrodomésticos, reparaciones, importe facturado y reparaciones en garantía.
- Tabla de las últimas 5 reparaciones registradas.
- Accesos rápidos a los demás módulos.

### Gestión de Datos (`GestionDatos.aspx`)
Interfaz con tres pestañas independientes:

| Pestaña          | Acciones disponibles                        |
|------------------|---------------------------------------------|
| Técnicos         | Registrar, listar                           |
| Clientes         | Registrar, cargar para editar, actualizar   |
| Electrodomésticos| Registrar, listar                           |

### Nueva Reparación (`RegistroReparacion.aspx`)
- Selección de técnico, cliente y electrodoméstico mediante `DropDownList` cargados desde la BD.
- Checkbox de garantía: deshabilita el campo de coste y lo establece en $0 automáticamente.
- Visualización del precio del electrodoméstico seleccionado.
- Resumen del total a facturar en tiempo real.

### Histórico (`Historico.aspx`)
- `GridView` paginado (10 registros por página).
- Búsqueda por técnico, cliente o electrodoméstico.
- Resumen financiero al pie: total de reparaciones, importe facturado y cantidad en garantía.

---

## Modelo de datos

```
Tecnicos
    IdTecnico   INT  PK IDENTITY
    NIF         NVARCHAR(20)  UNIQUE
    Nombre      NVARCHAR(100)
    Apellidos   NVARCHAR(150)
    Celular     NVARCHAR(20)

Clientes
    IdCliente       INT  PK IDENTITY
    Identificacion  NVARCHAR(20)  UNIQUE
    Nombre          NVARCHAR(100)
    Apellidos       NVARCHAR(150)
    Direccion       NVARCHAR(250)
    Celular         NVARCHAR(20)

Electrodomesticos
    IdElectrodomestico  INT  PK IDENTITY
    Tipo                NVARCHAR(100)
    Modelo              NVARCHAR(150)
    Precio              DECIMAL(10,2)

Reparaciones
    IdReparacion        INT  PK IDENTITY
    IdTecnico           INT  FK → Tecnicos
    IdCliente           INT  FK → Clientes
    IdElectrodomestico  INT  FK → Electrodomesticos
    Descripcion         NVARCHAR(500)
    Coste               DECIMAL(10,2)
    EnGarantia          BIT
    Fecha               DATETIME
```

---

## Capa de lógica de negocio

Los modelos en `Models/` encapsulan tanto los datos como la lógica:

| Clase              | Métodos de negocio                                      |
|--------------------|---------------------------------------------------------|
| `Tecnico`          | `Registrar()`, `Consultar()`                            |
| `Cliente`          | `Registrar()`, `ActualizarDatos()`, `Consultar()`       |
| `Electrodomestico` | `Registrar()`, `Consultar()`                            |
| `Reparacion`       | `AsignarTecnico()`, `CalcularTotal()`, `VerificarGarantia()`, `Registrar()`, `ConsultarTodas()`, `ObtenerEstadisticas()`, `ObtenerRecientes()` |

**Regla de garantía:** `CalcularTotal()` retorna `0` cuando `EnGarantia = true`, independientemente del coste registrado.

---

## Validaciones

### Lado servidor (ASP.NET Validators)

| Campo            | Validador                    | Regla                                      |
|------------------|------------------------------|--------------------------------------------|
| NIF técnico      | `RegularExpressionValidator` | `^\d{8}[A-Za-z]$`                         |
| Número celular   | `RegularExpressionValidator` | `^3\d{9}$` (formato Colombia, 10 dígitos) |
| Precio / Coste   | `RegularExpressionValidator` | `^\d+([.,]\d{1,2})?$`                     |
| Todos los campos | `RequiredFieldValidator`     | Campo obligatorio                          |

### Lado servidor (code-behind)
- Verificación de selección en `DropDownList` antes de insertar una reparación.
- Captura de violaciones `UNIQUE` con mensaje de error descriptivo.
- `HttpUtility.HtmlDecode` al cargar datos del `GridView` para evitar errores de `Request Validation`.

---

## Moneda

El sistema utiliza **Pesos Colombianos (COP)**. La cultura `es-CO` está configurada globalmente en `Web.config`, por lo que todos los formatos `{0:C2}` producen automáticamente el formato `$ 1.000,00`.

```xml
<globalization requestEncoding="utf-8" responseEncoding="utf-8"
               culture="es-CO" uiCulture="es-CO" fileEncoding="utf-8" />
```
