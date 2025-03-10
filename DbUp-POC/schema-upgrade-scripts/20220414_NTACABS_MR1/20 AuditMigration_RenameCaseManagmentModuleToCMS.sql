USE [cabs_production]
GO

BEGIN TRANSACTION;
GO

UPDATE [audit].[Module] SET [Name] = 'CMS' WHERE [ModuleId] = '7'
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20220722075015_CMSModuleName', N'6.0.0');
GO

COMMIT;
GO

