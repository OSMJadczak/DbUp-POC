USE [cabs_production]
GO

BEGIN TRANSACTION;
GO

ALTER TABLE [letters].[Letter] ADD [VehicleLicenceNumber] NVARCHAR(10) NOT NULL DEFAULT '';
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES(N'20231010101946_Add-Vehicle-Licence-Column', N'7.0.11');
GO

COMMIT;
GO