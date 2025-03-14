BEGIN TRANSACTION;
GO

DECLARE @var0 sysname;
SELECT @var0 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[CABS_ENF].[FineNote]') AND [c].[name] = N'NoteType');
IF @var0 IS NOT NULL EXEC(N'ALTER TABLE [CABS_ENF].[FineNote] DROP CONSTRAINT [' + @var0 + '];');
ALTER TABLE [CABS_ENF].[FineNote] DROP COLUMN [NoteType];
GO

DELETE FROM [__EFMigrationsHistory]
WHERE [MigrationId] = N'20240208131356_AddFineNoteType';
GO

COMMIT;
GO