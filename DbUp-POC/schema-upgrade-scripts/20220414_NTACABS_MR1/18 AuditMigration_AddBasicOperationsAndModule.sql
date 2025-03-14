USE [cabs_production]
GO

BEGIN TRANSACTION;
GO

INSERT INTO [audit].[ProcessType](ProcessTypeId, Name) VALUES($41, 'Add Grant')
GO

INSERT INTO [audit].[ProcessType](ProcessTypeId, Name) VALUES($42, 'Update Grant')
GO

INSERT INTO [audit].[ProcessType](ProcessTypeId, Name) VALUES($51, 'Add Grant Limit')
GO

INSERT INTO [audit].[Module](ModuleId, Name) VALUES($7, 'CaseManagement')
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20220614083204_AddCaseManagement', N'6.0.0');
GO

COMMIT;
GO

