USE [cabs_production]
GO

BEGIN TRANSACTION;
GO
ALTER TABLE [letters].[Letter] ADD [IssuedFineId] int NULL;
GO
INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20231003111218_AddFineId', N'7.0.11');
GO
COMMIT;
GO