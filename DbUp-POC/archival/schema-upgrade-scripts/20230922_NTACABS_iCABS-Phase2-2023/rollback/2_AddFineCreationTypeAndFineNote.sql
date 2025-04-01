USE [cabs_production]
GO

BEGIN TRANSACTION;
GO

DROP TABLE [CABS_ENF].[FineNote];
GO

DELETE FROM [__EFMigrationsHistory]
WHERE [MigrationId] = N'20230912120505_Enforcement.AddFineNotes';
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

DECLARE @var0 sysname;
SELECT @var0 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[CABS_ENF].[Fines]') AND [c].[name] = N'FineCreationType');
IF @var0 IS NOT NULL EXEC(N'ALTER TABLE [CABS_ENF].[Fines] DROP CONSTRAINT [' + @var0 + '];');
ALTER TABLE [CABS_ENF].[Fines] DROP COLUMN [FineCreationType];
GO

DELETE FROM [__EFMigrationsHistory]
WHERE [MigrationId] = N'20230912081804_AddFineCreationType';
GO

COMMIT;
GO
