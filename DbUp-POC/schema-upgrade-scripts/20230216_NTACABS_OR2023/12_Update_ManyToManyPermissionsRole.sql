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

ALTER TABLE [or].[RolePermissions] DROP CONSTRAINT [FK_RolePermissions_Permissions_PermissionId];
GO

ALTER TABLE [or].[RolePermissions] DROP CONSTRAINT [FK_RolePermissions_Roles_RoleId];
GO

ALTER TABLE [or].[RolePermissions] DROP CONSTRAINT [PK_RolePermissions];
GO

DROP INDEX [IX_RolePermissions_PermissionId] ON [or].[RolePermissions];
GO

DECLARE @var0 sysname;
SELECT @var0 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[or].[Roles]') AND [c].[name] = N'Name');
IF @var0 IS NOT NULL EXEC(N'ALTER TABLE [or].[Roles] DROP CONSTRAINT [' + @var0 + '];');
ALTER TABLE [or].[Roles] ALTER COLUMN [Name] nvarchar(450) NOT NULL;
GO

ALTER TABLE [or].[RolePermissions] ADD CONSTRAINT [PK_RolePermissions] PRIMARY KEY ([PermissionId], [RoleId]);
GO

CREATE UNIQUE INDEX [IX_Roles_Name] ON [or].[Roles] ([Name]);
GO

CREATE INDEX [IX_RolePermissions_RoleId] ON [or].[RolePermissions] ([RoleId]);
GO

ALTER TABLE [or].[RolePermissions] ADD CONSTRAINT [FK_RolePermissions_Permissions_PermissionId] FOREIGN KEY ([PermissionId]) REFERENCES [or].[Permissions] ([Id]) ON DELETE CASCADE;
GO

ALTER TABLE [or].[RolePermissions] ADD CONSTRAINT [FK_RolePermissions_Roles_RoleId] FOREIGN KEY ([RoleId]) REFERENCES [or].[Roles] ([Id]) ON DELETE CASCADE;
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20230419132144_RolePermissionsRelationships', N'7.0.5');
GO

COMMIT;
GO

