BEGIN TRANSACTION;
GO

IF EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20240711104141_PersonDocumentProcessTypes'
)
BEGIN
    DELETE FROM audit.ProcessType WHERE ProcessTypeId IN (300,301)
END;
GO

IF EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20240711104141_PersonDocumentProcessTypes'
)
BEGIN
    DELETE FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20240711104141_PersonDocumentProcessTypes';
END;
GO

COMMIT;
GO

