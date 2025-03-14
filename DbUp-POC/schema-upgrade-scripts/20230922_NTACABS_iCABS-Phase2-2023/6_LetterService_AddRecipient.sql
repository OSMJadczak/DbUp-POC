USE [cabs_production]
GO

BEGIN TRANSACTION;
GO

ALTER TABLE [letters].[Letter] ADD [RecipientPersonId] int NOT NULL DEFAULT 0;
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20231002104857_LetterService_AddRecipient', N'7.0.11');
GO

COMMIT;
GO

