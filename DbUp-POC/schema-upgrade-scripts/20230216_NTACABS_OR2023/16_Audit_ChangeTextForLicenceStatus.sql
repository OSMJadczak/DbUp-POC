BEGIN TRANSACTION;
GO

update [audit].[ProcessType] set Name = 'Update Licence Details' where ProcessTypeId = 14
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20230508134600_ChangeTextForAuditLicenceStatus', N'6.0.0');
GO

COMMIT;
GO

