USE [cabs_production]
GO

BEGIN TRANSACTION;
GO

INSERT INTO [audit].[ProcessType](ProcessTypeId, Name) VALUES($53, 'Grant Printed')
GO

INSERT INTO [audit].[ProcessType](ProcessTypeId, Name) VALUES($54, 'Details Email Sent')
GO

INSERT INTO [audit].[ProcessType](ProcessTypeId, Name) VALUES($55, 'Reply Email Sent')
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20220725103951_AddCMSGrantPrintAndEmailAudits', N'6.0.0');
GO

COMMIT;
GO



