ALTER TABLE [person].[Individual] DROP CONSTRAINT [FK_Individual_To_Title];

GO

ALTER TABLE [person].[PhoneUsage] SET (SYSTEM_VERSIONING = OFF);

GO

DROP TABLE [person].[PhoneUsageHistory]

GO

DROP TABLE [person].[PhoneUsage];

GO

ALTER TABLE [person].[Title] SET (SYSTEM_VERSIONING = OFF);

GO

DROP TABLE [person].[TitleHistory]

GO

DROP TABLE [person].[Title];

GO

ALTER TABLE [person].[ContactUsage] SET (SYSTEM_VERSIONING = OFF);

GO

DROP TABLE [person].[ContactUsageHistory]

GO

DROP TABLE [person].[ContactUsage];

GO

DROP INDEX [IX_Individual_TitleId] ON [person].[Individual];

GO

DECLARE @var0 sysname;
SELECT @var0 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[person].[Individual]') AND [c].[name] = N'TitleId');
IF @var0 IS NOT NULL EXEC(N'ALTER TABLE [person].[Individual] DROP CONSTRAINT [' + @var0 + '];');
ALTER TABLE [person].[Individual] DROP COLUMN [TitleId];

GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20200415135857_RemoveSmSOptIn', N'2.2.2-servicing-10034');

GO

