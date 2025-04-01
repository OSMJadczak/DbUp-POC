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

IF SCHEMA_ID(N'or') IS NULL EXEC(N'CREATE SCHEMA [or];');
GO

CREATE TABLE [or].[SearchLogs] (
    [Id] int NOT NULL IDENTITY,
    [SearchType] nvarchar(max) NOT NULL,
    [SearchParams] nvarchar(max) NOT NULL,
    CONSTRAINT [PK_SearchLogs] PRIMARY KEY ([Id])
);
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20230308073718_Init_OnlineRegister_Licences_Module', N'6.0.14');
GO

COMMIT;
GO

