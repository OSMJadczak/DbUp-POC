USE cabs_production;
GO

DECLARE @var0 sysname;
SELECT @var0 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[dbo].[LicenceMasterVL]') AND [c].[name] = N'PreBookingQueryRequired');
IF @var0 IS NOT NULL EXEC(N'ALTER TABLE [dbo].[LicenceMasterVL] DROP CONSTRAINT [' + @var0 + '];');

ALTER TABLE LicenceMasterVL DROP COLUMN PreBookingQueryRequired;

SELECT @var0 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[dbo].[LicenceMasterVLAudit]') AND [c].[name] = N'PreBookingQueryRequired');
IF @var0 IS NOT NULL EXEC(N'ALTER TABLE [dbo].[LicenceMasterVLAudit] DROP CONSTRAINT [' + @var0 + '];');

ALTER TABLE LicenceMasterVLAudit DROP COLUMN PreBookingQueryRequired;
