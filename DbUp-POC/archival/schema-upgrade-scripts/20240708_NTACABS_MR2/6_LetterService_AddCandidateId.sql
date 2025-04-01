BEGIN TRANSACTION;
GO

ALTER TABLE [letters].[Letter] ADD [CandidateId] int NULL;
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20240806131433_AddCandidateId', N'7.0.11');
GO

COMMIT;
GO

