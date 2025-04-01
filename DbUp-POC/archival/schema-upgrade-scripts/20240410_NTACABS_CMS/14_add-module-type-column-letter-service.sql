BEGIN TRANSACTION;
GO

use cabs_production;
go

IF NOT EXISTS(SELECT * FROM dbo.[__EFMigrationsHistory] WHERE [MigrationId] = N'20241002090557_AddModuleType')
BEGIN
    ALTER TABLE [letters].[Letter] ADD [ModuleType] int NOT NULL DEFAULT 1;
END;
GO

IF NOT EXISTS(SELECT * FROM dbo.[__EFMigrationsHistory] WHERE [MigrationId] = N'20241002090557_AddModuleType')
BEGIN
    INSERT INTO dbo.[__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20241002090557_AddModuleType', N'7.0.11');
END;
GO

COMMIT;
GO