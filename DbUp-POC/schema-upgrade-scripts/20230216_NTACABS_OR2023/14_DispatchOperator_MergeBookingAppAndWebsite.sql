BEGIN TRANSACTION;
GO

update do.LicenceMaster set Website = BookingApplication where Website is null or Website = ''
GO

DECLARE @var0 sysname;
SELECT @var0 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[do].[LicenceMaster]') AND [c].[name] = N'BookingApplication');
IF @var0 IS NOT NULL EXEC(N'ALTER TABLE [do].[LicenceMaster] DROP CONSTRAINT [' + @var0 + '];');
ALTER TABLE [do].[LicenceMaster] DROP COLUMN [BookingApplication];
GO

EXEC sp_rename N'[do].[LicenceMaster].[Website]', N'BookingAppOrWebsite', N'COLUMN';
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20230425102403_DispatchOperator_MergeBookingAppAndWebsite', N'7.0.4');
GO

COMMIT;
GO

