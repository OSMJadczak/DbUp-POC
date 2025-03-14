USE [cabs_production]
GO

BEGIN TRANSACTION;
GO

DECLARE @var4 sysname;
SELECT @var4 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[CABS_ENF].[FineNote]') AND [c].[name] = N'NoteContent');
IF @var4 IS NOT NULL EXEC(N'ALTER TABLE [CABS_ENF].[FineNote] DROP CONSTRAINT [' + @var4 + '];');
ALTER TABLE [CABS_ENF].[FineNote] ALTER COLUMN [NoteContent] nvarchar(2000) NOT NULL;
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20231024085016_editFineNote', N'6.0.0');
GO

COMMIT;
GO