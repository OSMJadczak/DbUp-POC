USE [cabs_production]
GO

BEGIN TRANSACTION;
GO

INSERT INTO [audit].[ProcessType](ProcessTypeId, Name) VALUES(64, 'Add Fine')
GO

INSERT INTO [audit].[ProcessType](ProcessTypeId, Name) VALUES(65, 'Update Fine')
GO

INSERT INTO [audit].[ProcessType](ProcessTypeId, Name) VALUES(66, 'Pay Fine')
GO

INSERT INTO [audit].[ProcessType](ProcessTypeId, Name) VALUES(69, 'Rescind Fine')
GO

INSERT INTO [audit].[ProcessType](ProcessTypeId, Name) VALUES(67, 'Manage Appeals')
GO

INSERT INTO [audit].[ProcessType](ProcessTypeId, Name) VALUES(68, 'Manage Legal')
GO

INSERT INTO [audit].[Module](ModuleId, Name) VALUES(9, 'Enforcement')
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20230915105838_IntegrateWithEnforcement', N'6.0.0');
GO

COMMIT;
GO

