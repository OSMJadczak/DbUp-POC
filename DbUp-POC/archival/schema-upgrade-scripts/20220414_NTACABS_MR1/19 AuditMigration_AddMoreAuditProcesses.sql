USE [cabs_production]
GO

BEGIN TRANSACTION;
GO

UPDATE [audit].[ProcessType] SET [Name] = 'Create Grant' WHERE ProcessTypeId = $41
GO

UPDATE [audit].[ProcessType] SET [Name] = 'Update Grant Applicant' WHERE ProcessTypeId = $43
GO

INSERT INTO [audit].[ProcessType](ProcessTypeId, Name) VALUES($44, 'Update Grant Settings')
GO

INSERT INTO [audit].[ProcessType](ProcessTypeId, Name) VALUES($45, 'Add Grant Attachment')
GO

INSERT INTO [audit].[ProcessType](ProcessTypeId, Name) VALUES($46, 'Remove Grant Attachment')
GO

INSERT INTO [audit].[ProcessType](ProcessTypeId, Name) VALUES($47, 'Approve Grant')
GO

INSERT INTO [audit].[ProcessType](ProcessTypeId, Name) VALUES($48, 'Reject Grant')
GO

INSERT INTO [audit].[ProcessType](ProcessTypeId, Name) VALUES($49, 'Withdraw Grant')
GO

INSERT INTO [audit].[ProcessType](ProcessTypeId, Name) VALUES($50, 'Extend Grant')
GO

INSERT INTO [audit].[ProcessType](ProcessTypeId, Name) VALUES($51, 'Create Grant Limit')
GO

INSERT INTO [audit].[ProcessType](ProcessTypeId, Name) VALUES($52, 'Update Grant Limit')
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20220718070656_CaseManagmentAddMoreGrantProcesses', N'6.0.0');
GO

COMMIT;
GO

