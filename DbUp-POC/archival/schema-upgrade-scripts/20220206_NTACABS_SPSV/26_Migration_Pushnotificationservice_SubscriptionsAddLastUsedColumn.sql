USE [cabs_production]
GO

BEGIN TRANSACTION;
GO

DECLARE @var0 sysname;
SELECT @var0 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[pushnotificationservice].[Subscriptions]') AND [c].[name] = N'CreatedDate');
IF @var0 IS NOT NULL EXEC(N'ALTER TABLE [pushnotificationservice].[Subscriptions] DROP CONSTRAINT [' + @var0 + '];');
GO

ALTER TABLE [pushnotificationservice].[Subscriptions] ADD [LastUsed] datetime2 NULL;
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20230113074006_PushNotificationsService_Subscription_AddLastUsedColumn', N'7.0.1');
GO

COMMIT;
GO