USE [test];

CREATE TABLE [Items] (
[Id] INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
[ItemName] VARCHAR(100),
[Price] DECIMAL(7,2),
[ColumnToChangeDatatype] VARCHAR(100))

INSERT INTO [Items] (ItemName, Price, ColumnToChangeDatatype) VALUES
('Umbrella', 30.5, 'Protects against the rain'),
('Water', 2, 'Good for hydration and hygiene'),
('Potato', 15, NULL)

CREATE TABLE TableToAdjust
([Id] INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
[Description] VARCHAR(200) NOT NULL,
[ColumnToDrop] BIT NOT NULL,
[ColumnToRename] BIT NOT NULL)

INSERT INTO [TableToAdjust] ([Description], ColumnToDrop, ColumnToRename) VALUES
('TF', 1, 0),
('FT', 0, 1),
('FF', 0, 0),
('TT', 1, 1)

CREATE TABLE [TableToDrop]
([TestColumn] BIT NOT NULL)

INSERT INTO [TableToDrop] VALUES (1), (0), (1)