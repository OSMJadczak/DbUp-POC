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

CREATE TABLE [or].[Permissions] (
    [Id] int NOT NULL IDENTITY,
    [Name] nvarchar(max) NOT NULL,
    CONSTRAINT [PK_Permissions] PRIMARY KEY ([Id])
);
GO

CREATE TABLE [or].[Roles] (
    [Id] int NOT NULL IDENTITY,
    [Name] nvarchar(max) NOT NULL,
    CONSTRAINT [PK_Roles] PRIMARY KEY ([Id])
);
GO

CREATE TABLE [or].[RolePermissions] (
    [RoleId] int NOT NULL,
    [PermissionId] int NOT NULL,
    CONSTRAINT [PK_RolePermissions] PRIMARY KEY ([RoleId], [PermissionId]),
    CONSTRAINT [FK_RolePermissions_Permissions_PermissionId] FOREIGN KEY ([PermissionId]) REFERENCES [or].[Permissions] ([Id]) ON DELETE NO ACTION,
    CONSTRAINT [FK_RolePermissions_Roles_RoleId] FOREIGN KEY ([RoleId]) REFERENCES [or].[Roles] ([Id]) ON DELETE NO ACTION
);
GO

CREATE INDEX [IX_RolePermissions_PermissionId] ON [or].[RolePermissions] ([PermissionId]);
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20230328111137_InitUserAccessTables', N'6.0.15');
GO

COMMIT;
GO

