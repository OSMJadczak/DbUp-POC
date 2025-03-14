USE [cabs_production]
GO

IF OBJECT_ID(N'[__EFMigrationsHistory]') IS NULL
BEGIN
    CREATE TABLE [__EFMigrationsHistory] (
        [MigrationId] nvarchar(150) NOT NULL,
        [ProductVersion] nvarchar(32) NOT NULL,
        CONSTRAINT [PK___EFMigrationsHistory] PRIMARY KEY ([MigrationId])
    );
END;
GO

BEGIN TRANSACTION;
GO

IF SCHEMA_ID(N'letters') IS NULL EXEC(N'CREATE SCHEMA [letters];');
GO

CREATE TABLE [letters].[LetterDespatchMethod] (
    [Id] int NOT NULL,
    [Name] nvarchar(50) NOT NULL,
    [CreatedBy] nvarchar(255) NOT NULL,
    [CreatedDate] datetime2 NOT NULL,
    [ModifiedBy] nvarchar(255) NULL,
    [ModifiedDate] datetime2 NULL,
    CONSTRAINT [PK_LetterDespatchMethod] PRIMARY KEY ([Id])
);
GO

CREATE TABLE [letters].[LetterStatus] (
    [Id] int NOT NULL,
    [Name] nvarchar(25) NOT NULL,
    [CreatedBy] nvarchar(255) NOT NULL,
    [CreatedDate] datetime2 NOT NULL,
    [ModifiedBy] nvarchar(255) NULL,
    [ModifiedDate] datetime2 NULL,
    CONSTRAINT [PK_LetterStatus] PRIMARY KEY ([Id])
);
GO

CREATE TABLE [letters].[Letter] (
    [Id] int NOT NULL IDENTITY,
    [DriverLicenceNumber] nvarchar(100) NOT NULL,
    [BatchId] nvarchar(50) NULL,
    [LetterRequestTypeVlId] int NOT NULL,
    [LetterRequestTypeVlAuditId] int NOT NULL,
    [Content] nvarchar(max) NOT NULL,
    [LetterDespatchMethodId] int NOT NULL,
    [CreatedBy] nvarchar(255) NOT NULL,
    [CreatedDate] datetime2 NOT NULL,
    [ModifiedBy] nvarchar(255) NULL,
    [ModifiedDate] datetime2 NULL,
    CONSTRAINT [PK_Letter] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_Letter_LetterDespatchMethod_LetterDespatchMethodId] FOREIGN KEY ([LetterDespatchMethodId]) REFERENCES [letters].[LetterDespatchMethod] ([Id]) ON DELETE NO ACTION
);
GO

CREATE TABLE [letters].[LetterDetail] (
    [Id] int NOT NULL IDENTITY,
    [LetterMasterId] int NOT NULL,
    [LetterStatusId] int NOT NULL,
    [DespatchData] nvarchar(max) NOT NULL,
    [CreatedBy] nvarchar(255) NOT NULL,
    [CreatedDate] datetime2 NOT NULL,
    [ModifiedBy] nvarchar(255) NULL,
    [ModifiedDate] datetime2 NULL,
    CONSTRAINT [PK_LetterDetail] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_LetterDetail_LetterStatus_LetterStatusId] FOREIGN KEY ([LetterStatusId]) REFERENCES [letters].[LetterStatus] ([Id]) ON DELETE NO ACTION,
    CONSTRAINT [FK_LetterDetail_Letter_LetterMasterId] FOREIGN KEY ([LetterMasterId]) REFERENCES [letters].[Letter] ([Id]) ON DELETE CASCADE
);
GO

CREATE INDEX [IX_Letter_LetterDespatchMethodId] ON [letters].[Letter] ([LetterDespatchMethodId]);
GO

CREATE INDEX [IX_LetterDetail_LetterMasterId] ON [letters].[LetterDetail] ([LetterMasterId]);
GO

CREATE INDEX [IX_LetterDetail_LetterStatusId] ON [letters].[LetterDetail] ([LetterStatusId]);
GO

INSERT INTO [letters].[LetterDespatchMethod]([Id],[Name],[CreatedBy],[CreatedDate]) VALUES (1,'Post','System',GETDATE())
GO

INSERT INTO [letters].[LetterDespatchMethod]([Id],[Name],[CreatedBy],[CreatedDate]) VALUES (2,'Courier','System',GETDATE())
GO

INSERT INTO [letters].[LetterDespatchMethod]([Id],[Name],[CreatedBy],[CreatedDate]) VALUES (3,'Email','System',GETDATE())
GO

INSERT INTO [letters].[LetterDespatchMethod]([Id],[Name],[CreatedBy],[CreatedDate]) VALUES (4,'SMS','System',GETDATE())
GO

INSERT INTO [letters].[LetterDespatchMethod]([Id],[Name],[CreatedBy],[CreatedDate]) VALUES (5,'OnlineOnly','System',GETDATE())
GO

INSERT INTO [letters].[LetterDespatchMethod]([Id],[Name],[CreatedBy],[CreatedDate]) VALUES (6,'NotSent','System',GETDATE())
GO

INSERT INTO [letters].[LetterStatus]([Id],[Name],[CreatedBy],[CreatedDate]) VALUES (1,'New','System',GETDATE())
GO

INSERT INTO [letters].[LetterStatus]([Id],[Name],[CreatedBy],[CreatedDate]) VALUES (2,'Printing','System',GETDATE())
GO

INSERT INTO [letters].[LetterStatus]([Id],[Name],[CreatedBy],[CreatedDate]) VALUES (3,'Completed','System',GETDATE())
GO

INSERT INTO [letters].[LetterStatus]([Id],[Name],[CreatedBy],[CreatedDate]) VALUES (4,'Cancelled','System',GETDATE())
GO

INSERT INTO [letters].[LetterStatus]([Id],[Name],[CreatedBy],[CreatedDate]) VALUES (5,'Failed','System',GETDATE())
GO

INSERT INTO [letters].[LetterStatus]([Id],[Name],[CreatedBy],[CreatedDate]) VALUES (6,'Rejected','System',GETDATE())
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20230922064516_Init_LetterService', N'7.0.11');
GO

COMMIT;
GO

