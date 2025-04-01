BEGIN TRANSACTION;
GO

IF EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20240723075942_RemoveOldFileReference')
BEGIN
    CREATE INDEX [IX_Ceased_FileId] ON [person].[Ceased] ([FileId]);
END;
GO

IF EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20240723075942_RemoveOldFileReference')
BEGIN
    ALTER TABLE [person].[Ceased] ADD CONSTRAINT [FK_Ceased_To_File] FOREIGN KEY ([FileId]) REFERENCES [person].[File] ([FileId]);
END;
GO

IF EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20240723075942_RemoveOldFileReference')
BEGIN
    DELETE FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20240723075942_RemoveOldFileReference';
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20240719083631_AddDocumentIdField')
BEGIN
    ALTER TABLE [person].[Ceased] DROP CONSTRAINT [FK_Ceased_To_Person_Document];
END;
GO

IF EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20240719083631_AddDocumentIdField')
BEGIN
    ALTER TABLE [person].[PersonDocuments] DROP CONSTRAINT [PK_PersonDocuments];
END;
GO

IF EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20240719083631_AddDocumentIdField')
BEGIN
    DROP INDEX [IX_PersonDocuments_PersonId_DocumentId] ON [person].[PersonDocuments];
END;
GO

IF EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20240719083631_AddDocumentIdField')
BEGIN
    DROP INDEX [IX_Ceased_DocumentId] ON [person].[Ceased];
END;
GO

IF EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20240719083631_AddDocumentIdField')
BEGIN
    DECLARE @var0 sysname;
    SELECT @var0 = [d].[name]
    FROM [sys].[default_constraints] [d]
    INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
    WHERE ([d].[parent_object_id] = OBJECT_ID(N'[person].[Ceased]') AND [c].[name] = N'DocumentId');
    IF @var0 IS NOT NULL EXEC(N'ALTER TABLE [person].[Ceased] DROP CONSTRAINT [' + @var0 + '];');
    ALTER TABLE [person].[Ceased] DROP COLUMN [DocumentId];
END;
GO

IF EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20240719083631_AddDocumentIdField')
BEGIN
    ALTER TABLE [person].[PersonDocuments] ADD CONSTRAINT [PK_PersonDocuments] PRIMARY KEY ([PersonId], [DocumentId]);
END;
GO

IF EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20240719083631_AddDocumentIdField')
BEGIN
    DELETE FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20240719083631_AddDocumentIdField';
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20240708121656_PersonDocumentEntity')
BEGIN
    DROP TABLE [person].[PersonDocuments];
END;
GO

IF EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20240708121656_PersonDocumentEntity')
BEGIN
    DELETE FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20240708121656_PersonDocumentEntity';
END;
GO

COMMIT;
GO

