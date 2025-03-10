BEGIN TRANSACTION;
GO

ALTER TABLE [CABS_ENF].[FineNote] ADD [NoteType] int NOT NULL DEFAULT 0;
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20240208131356_AddFineNoteType', N'6.0.0');
GO

COMMIT;
GO

