-- ============================================================
-- Script de creación de base de datos: GestionReparaciones
-- Servicio Técnico de Electrodomésticos
-- Ejecutar en SQL Server Express antes de iniciar la aplicación
-- ============================================================

-- Crear la base de datos si no existe
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'GestionReparaciones')
BEGIN
    CREATE DATABASE GestionReparaciones;
END
GO

USE GestionReparaciones;
GO

-- ============================================================
-- Tabla: Tecnicos
-- Almacena los técnicos del servicio
-- ============================================================
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Tecnicos')
BEGIN
    CREATE TABLE Tecnicos (
        IdTecnico   INT            IDENTITY(1,1) PRIMARY KEY,
        NIF         NVARCHAR(20)   NOT NULL UNIQUE,
        Nombre      NVARCHAR(100)  NOT NULL,
        Apellidos   NVARCHAR(150)  NOT NULL,
        Celular     NVARCHAR(20)   NOT NULL
    );
END
GO

-- ============================================================
-- Tabla: Clientes
-- Almacena los clientes que solicitan reparaciones
-- ============================================================
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Clientes')
BEGIN
    CREATE TABLE Clientes (
        IdCliente       INT            IDENTITY(1,1) PRIMARY KEY,
        Identificacion  NVARCHAR(20)   NOT NULL UNIQUE,
        Nombre          NVARCHAR(100)  NOT NULL,
        Apellidos       NVARCHAR(150)  NOT NULL,
        Direccion       NVARCHAR(250)  NOT NULL,
        Celular         NVARCHAR(20)   NOT NULL
    );
END
GO

-- ============================================================
-- Tabla: Electrodomesticos
-- Catálogo de tipos de electrodomésticos reparables
-- ============================================================
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Electrodomesticos')
BEGIN
    CREATE TABLE Electrodomesticos (
        IdElectrodomestico  INT            IDENTITY(1,1) PRIMARY KEY,
        Tipo                NVARCHAR(100)  NOT NULL,
        Modelo              NVARCHAR(150)  NOT NULL,
        Precio              DECIMAL(10,2)  NOT NULL DEFAULT 0
    );
END
GO

-- ============================================================
-- Tabla: Reparaciones
-- Registro histórico de todas las reparaciones realizadas
-- Integridad referencial con las tres tablas anteriores
-- ============================================================
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Reparaciones')
BEGIN
    CREATE TABLE Reparaciones (
        IdReparacion        INT            IDENTITY(1,1) PRIMARY KEY,
        IdTecnico           INT            NOT NULL,
        IdCliente           INT            NOT NULL,
        IdElectrodomestico  INT            NOT NULL,
        Descripcion         NVARCHAR(500)  NOT NULL,
        Coste               DECIMAL(10,2)  NOT NULL DEFAULT 0,
        EnGarantia          BIT            NOT NULL DEFAULT 0,
        Fecha               DATETIME       NOT NULL DEFAULT GETDATE(),

        -- Restricciones de clave foránea para garantizar la integridad referencial
        CONSTRAINT FK_Reparaciones_Tecnicos
            FOREIGN KEY (IdTecnico) REFERENCES Tecnicos(IdTecnico),
        CONSTRAINT FK_Reparaciones_Clientes
            FOREIGN KEY (IdCliente) REFERENCES Clientes(IdCliente),
        CONSTRAINT FK_Reparaciones_Electrodomesticos
            FOREIGN KEY (IdElectrodomestico) REFERENCES Electrodomesticos(IdElectrodomestico)
    );
END
GO

-- ============================================================
-- Datos de ejemplo para pruebas iniciales
-- ============================================================
IF NOT EXISTS (SELECT TOP 1 1 FROM Tecnicos)
BEGIN
    INSERT INTO Tecnicos (NIF, Nombre, Apellidos, Celular) VALUES
        ('12345678A', 'Carlos',  'García López',    '3001112222'),
        ('87654321B', 'María',   'Fernández Ruiz',  '3103334444'),
        ('11223344C', 'Antonio', 'Martínez Pérez',  '3155556666');
END
GO

IF NOT EXISTS (SELECT TOP 1 1 FROM Clientes)
BEGIN
    INSERT INTO Clientes (Identificacion, Nombre, Apellidos, Direccion, Celular) VALUES
        ('99887766D', 'Juan',    'Sánchez Torres',  'Calle Mayor 1, Madrid',       '3001002001'),
        ('55443322E', 'Laura',   'Gómez Herrera',   'Av. Libertad 45, Valencia',   '3113004001'),
        ('33221100F', 'Pedro',   'López Moreno',    'C/ Rosales 12, Sevilla',      '3205006001');
END
GO

IF NOT EXISTS (SELECT TOP 1 1 FROM Electrodomesticos)
BEGIN
    INSERT INTO Electrodomesticos (Tipo, Modelo, Precio) VALUES
        ('Lavadora',      'Samsung WW80T534DTW',   3699900.00),
        ('Frigorífico',   'LG GBB61PZGCN',         3200000.00),
        ('Lavavajillas',  'Bosch SMS46KI01E',       1200000.00),
        ('Horno',         'Siemens HB578G6S6',      800000.00),
        ('Microondas',    'Panasonic NN-GT46K',     399999.99);
END
GO

PRINT 'Base de datos GestionReparaciones creada y configurada correctamente.';
GO
