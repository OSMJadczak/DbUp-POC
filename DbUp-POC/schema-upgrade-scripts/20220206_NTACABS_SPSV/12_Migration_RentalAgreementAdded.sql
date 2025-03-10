BEGIN TRANSACTION;
GO

INSERT INTO [audit].[ProcessType](ProcessTypeId, Name) VALUES($57, 'Vehicle Rental Agreement Created')
GO

INSERT INTO [audit].[ProcessType](ProcessTypeId, Name) VALUES($58, 'Vehicle Rental Agreement Updated')
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20221103100243_RentalAgreement', N'6.0.0');
GO

COMMIT;
GO

