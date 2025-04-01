BEGIN TRANSACTION;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20240711104141_PersonDocumentProcessTypes'
)
BEGIN
    INSERT INTO audit.ProcessType VALUES
                    (300,'Person Document Uploaded'),
                    (301,'Person Document Removed')
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20240711104141_PersonDocumentProcessTypes'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20240711104141_PersonDocumentProcessTypes', N'8.0.4');
END;
GO

COMMIT;
GO

