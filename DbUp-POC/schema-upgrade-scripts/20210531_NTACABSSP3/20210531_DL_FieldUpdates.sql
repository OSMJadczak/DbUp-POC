DECLARE @var0 sysname;
SELECT @var0 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[dl].[LetterRequestMaster]') AND [c].[name] = N'HolderName');
IF @var0 IS NOT NULL EXEC(N'ALTER TABLE [dl].[LetterRequestMaster] DROP CONSTRAINT [' + @var0 + '];');
ALTER TABLE [dl].[LetterRequestMaster] ALTER COLUMN [HolderName] varchar(101) NULL;
ALTER TABLE [dl].[LetterRequestMaster] ADD DEFAULT (('')) FOR [HolderName];

GO

DECLARE @var1 sysname;
SELECT @var1 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[dl].[LetterRequestMaster]') AND [c].[name] = N'DriverAddress3');
IF @var1 IS NOT NULL EXEC(N'ALTER TABLE [dl].[LetterRequestMaster] DROP CONSTRAINT [' + @var1 + '];');
ALTER TABLE [dl].[LetterRequestMaster] ALTER COLUMN [DriverAddress3] nvarchar(50) NULL;
ALTER TABLE [dl].[LetterRequestMaster] ADD DEFAULT (('')) FOR [DriverAddress3];

GO

DECLARE @var2 sysname;
SELECT @var2 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[dl].[LetterRequestMaster]') AND [c].[name] = N'DriverAddress2');
IF @var2 IS NOT NULL EXEC(N'ALTER TABLE [dl].[LetterRequestMaster] DROP CONSTRAINT [' + @var2 + '];');
ALTER TABLE [dl].[LetterRequestMaster] ALTER COLUMN [DriverAddress2] nvarchar(50) NULL;
ALTER TABLE [dl].[LetterRequestMaster] ADD DEFAULT (('')) FOR [DriverAddress2];

GO

DECLARE @var3 sysname;
SELECT @var3 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[dl].[LetterRequestMaster]') AND [c].[name] = N'DriverAddress1');
IF @var3 IS NOT NULL EXEC(N'ALTER TABLE [dl].[LetterRequestMaster] DROP CONSTRAINT [' + @var3 + '];');
ALTER TABLE [dl].[LetterRequestMaster] ALTER COLUMN [DriverAddress1] nvarchar(50) NOT NULL;

GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20210223122445_LetterRequestMaster', N'2.2.2-servicing-10034');

GO

DECLARE @var4 sysname;
SELECT @var4 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[dl].[LetterRequestMaster]') AND [c].[name] = N'TaxClearanceName');
IF @var4 IS NOT NULL EXEC(N'ALTER TABLE [dl].[LetterRequestMaster] DROP CONSTRAINT [' + @var4 + '];');
ALTER TABLE [dl].[LetterRequestMaster] ALTER COLUMN [TaxClearanceName] nvarchar(101) NULL;

GO

DECLARE @var5 sysname;
SELECT @var5 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[dl].[LetterRequestMaster]') AND [c].[name] = N'HolderName');
IF @var5 IS NOT NULL EXEC(N'ALTER TABLE [dl].[LetterRequestMaster] DROP CONSTRAINT [' + @var5 + '];');
ALTER TABLE [dl].[LetterRequestMaster] ALTER COLUMN [HolderName] varchar(101) NULL;
ALTER TABLE [dl].[LetterRequestMaster] ADD DEFAULT (('')) FOR [HolderName];

GO

DECLARE @var6 sysname;
SELECT @var6 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[dl].[LetterRequestMaster]') AND [c].[name] = N'DriverAddress3');
IF @var6 IS NOT NULL EXEC(N'ALTER TABLE [dl].[LetterRequestMaster] DROP CONSTRAINT [' + @var6 + '];');
ALTER TABLE [dl].[LetterRequestMaster] ALTER COLUMN [DriverAddress3] nvarchar(50) NULL;
ALTER TABLE [dl].[LetterRequestMaster] ADD DEFAULT (('')) FOR [DriverAddress3];

GO

DECLARE @var7 sysname;
SELECT @var7 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[dl].[LetterRequestMaster]') AND [c].[name] = N'DriverAddress2');
IF @var7 IS NOT NULL EXEC(N'ALTER TABLE [dl].[LetterRequestMaster] DROP CONSTRAINT [' + @var7 + '];');
ALTER TABLE [dl].[LetterRequestMaster] ALTER COLUMN [DriverAddress2] nvarchar(50) NULL;
ALTER TABLE [dl].[LetterRequestMaster] ADD DEFAULT (('')) FOR [DriverAddress2];

GO

DECLARE @var8 sysname;
SELECT @var8 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[dl].[LetterRequestMaster]') AND [c].[name] = N'DriverAddress1');
IF @var8 IS NOT NULL EXEC(N'ALTER TABLE [dl].[LetterRequestMaster] DROP CONSTRAINT [' + @var8 + '];');
ALTER TABLE [dl].[LetterRequestMaster] ALTER COLUMN [DriverAddress1] nvarchar(50) NOT NULL;

GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20210531132723_PrintCardTaxClearnce', N'2.2.2-servicing-10034');

GO

