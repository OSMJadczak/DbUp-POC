BEGIN TRANSACTION;
GO

ALTER TABLE [do].[LicenceMaster] DROP CONSTRAINT [FK_LicenceMaster_CountyOfOperator_CountyId];
GO

ALTER TABLE [do].[CountyOfOperator] DROP CONSTRAINT [PK_CountyOfOperator];
GO

EXEC sp_rename N'[do].[CountyOfOperator]', N'CountyOfOperation';
GO

ALTER TABLE [do].[CountyOfOperation] ADD CONSTRAINT [PK_CountyOfOperation] PRIMARY KEY ([Id]);
GO

ALTER TABLE [do].[LicenceMaster] ADD CONSTRAINT [FK_LicenceMaster_CountyOfOperation_CountyId] FOREIGN KEY ([CountyId]) REFERENCES [do].[CountyOfOperation] ([Id]) ON DELETE NO ACTION;
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20230601084719_DispatchOperator_RenameCountyOfOperation', N'7.0.5');
GO

COMMIT;
GO

