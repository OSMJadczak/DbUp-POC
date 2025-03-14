USE [cabs_production]
GO

BEGIN TRANSACTION;
GO

DELETE FROM [audit].[ProcessType] WHERE ProcessTypeId = 64
GO

DELETE FROM [audit].[ProcessType] WHERE ProcessTypeId = 65
GO

DELETE FROM [audit].[ProcessType] WHERE ProcessTypeId = 69
GO

DELETE FROM [audit].[ProcessType] WHERE ProcessTypeId = 68
GO

DELETE FROM [audit].[ProcessType] WHERE ProcessTypeId = 67
GO

DELETE FROM [audit].[ProcessType] WHERE ProcessTypeId = 66
GO

DELETE FROM [audit].[Module] WHERE ModuleId = 9
GO

DELETE FROM [__EFMigrationsHistory]
WHERE [MigrationId] = N'20230915105838_IntegrateWithEnforcement';
GO

COMMIT;
GO
