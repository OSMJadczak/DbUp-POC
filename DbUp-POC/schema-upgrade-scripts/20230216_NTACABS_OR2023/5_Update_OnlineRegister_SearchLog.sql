BEGIN TRANSACTION;
GO

ALTER TABLE [or].[SearchLogs] ADD [IpAddress] nvarchar(max) NULL;
GO

ALTER TABLE [or].[SearchLogs] ADD [Timestamp] datetime2 NOT NULL DEFAULT '0001-01-01T00:00:00.0000000';
GO

ALTER TABLE [or].[SearchLogs] ADD [UserName] nvarchar(max) NULL;
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20230314123840_Update_OnlineRegister_SearchLog', N'6.0.14');
GO

COMMIT;
GO

