BEGIN TRANSACTION;
GO

DECLARE @var0 sysname;
SELECT @var0 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[letters].[Letter]') AND [c].[name] = N'VehicleLicenceNumber');
IF @var0 IS NOT NULL EXEC(N'ALTER TABLE [letters].[Letter] DROP CONSTRAINT [' + @var0 + '];');
ALTER TABLE [letters].[Letter] ALTER COLUMN [VehicleLicenceNumber] nvarchar(10) NULL;
GO

DECLARE @var1 sysname;
SELECT @var1 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[letters].[Letter]') AND [c].[name] = N'DriverLicenceNumber');
IF @var1 IS NOT NULL EXEC(N'ALTER TABLE [letters].[Letter] DROP CONSTRAINT [' + @var1 + '];');
ALTER TABLE [letters].[Letter] ALTER COLUMN [DriverLicenceNumber] nvarchar(10) NULL;
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20231107121825_Nullable_Licence_Fields', N'7.0.11');
GO

COMMIT;
GO

