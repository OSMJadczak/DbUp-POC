BEGIN TRANSACTION;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20240708121656_PersonDocumentEntity')
BEGIN
    CREATE TABLE [person].[PersonDocuments] (
        [PersonId] int NOT NULL,
        [DocumentId] uniqueidentifier NOT NULL,
        [DocumentName] nvarchar(256) NOT NULL,
        [DocumentType] nvarchar(max) NOT NULL,
        [CreatedAt] datetime2 NOT NULL,
        [CreatedBy] nvarchar(256) NOT NULL,
        CONSTRAINT [PK_PersonDocuments] PRIMARY KEY ([PersonId], [DocumentId]),
        CONSTRAINT [FK_PersonDocuments_Person_PersonId] FOREIGN KEY ([PersonId]) REFERENCES [person].[Person] ([PersonId]) ON DELETE CASCADE
    );
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20240708121656_PersonDocumentEntity')
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20240708121656_PersonDocumentEntity', N'6.0.0');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20240719083631_AddDocumentIdField')
BEGIN
    ALTER TABLE [person].[PersonDocuments] DROP CONSTRAINT [PK_PersonDocuments];
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20240719083631_AddDocumentIdField')
BEGIN
    ALTER TABLE [person].[Ceased] ADD [DocumentId] uniqueidentifier NULL;
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20240719083631_AddDocumentIdField')
BEGIN
    ALTER TABLE [person].[PersonDocuments] ADD CONSTRAINT [PK_PersonDocuments] PRIMARY KEY ([DocumentId]);
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20240719083631_AddDocumentIdField')
BEGIN
    CREATE INDEX [IX_PersonDocuments_PersonId_DocumentId] ON [person].[PersonDocuments] ([PersonId], [DocumentId]);
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20240719083631_AddDocumentIdField')
BEGIN
    CREATE INDEX [IX_Ceased_DocumentId] ON [person].[Ceased] ([DocumentId]);
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20240719083631_AddDocumentIdField')
BEGIN
    ALTER TABLE [person].[Ceased] ADD CONSTRAINT [FK_Ceased_To_Person_Document] FOREIGN KEY ([DocumentId]) REFERENCES [person].[PersonDocuments] ([DocumentId]);
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20240719083631_AddDocumentIdField')
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20240719083631_AddDocumentIdField', N'6.0.0');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20240723075942_RemoveOldFileReference')
BEGIN
    ALTER TABLE [person].[Ceased] DROP CONSTRAINT [FK_Ceased_To_File];
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20240723075942_RemoveOldFileReference')
BEGIN
    DROP INDEX [IX_Ceased_FileId] ON [person].[Ceased];
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20240723075942_RemoveOldFileReference')
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20240723075942_RemoveOldFileReference', N'6.0.0');
END;
GO

COMMIT;
GO

