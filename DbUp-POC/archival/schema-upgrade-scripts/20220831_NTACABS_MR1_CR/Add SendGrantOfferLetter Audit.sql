USE cabs_production
GO

BEGIN TRANSACTION;
GO

INSERT INTO [audit].[ProcessType](ProcessTypeId, Name) VALUES($56, 'Send Grant Offer Letter')
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20220831074937_AddCMSSendGrantOfferLetter', N'6.0.0');
GO

COMMIT;
GO

