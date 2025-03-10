BEGIN TRANSACTION;
GO

ALTER TABLE [dl].[LicenceMaster] ADD [RenewalPaymentDate] datetime2 NULL;
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20230420084057_AddRenewalPaymentDateToLicenceMasterEntity', N'6.0.0');
GO

COMMIT;
GO

