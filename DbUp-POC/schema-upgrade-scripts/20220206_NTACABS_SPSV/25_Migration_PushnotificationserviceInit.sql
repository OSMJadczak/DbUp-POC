USE [cabs_production]
GO

IF OBJECT_ID(N'[__EFMigrationsHistory]') IS NULL
BEGIN
    CREATE TABLE [__EFMigrationsHistory] (
        [MigrationId] nvarchar(150) NOT NULL,
        [ProductVersion] nvarchar(32) NOT NULL,
        CONSTRAINT [PK___EFMigrationsHistory] PRIMARY KEY ([MigrationId])
    );
END;
GO

BEGIN TRANSACTION;
GO

IF SCHEMA_ID(N'pushnotificationservice') IS NULL EXEC(N'CREATE SCHEMA [pushnotificationservice];');
GO

CREATE TABLE [pushnotificationservice].[Subscriptions] (
    [Id] int NOT NULL IDENTITY,
    [UserId] uniqueidentifier NOT NULL,
    [DeviceToken] nvarchar(255) NOT NULL,
    [CreatedDate] datetime2 NOT NULL DEFAULT (getdate()),
    CONSTRAINT [PK_Subscriptions] PRIMARY KEY ([Id])
);
GO

CREATE UNIQUE INDEX [IX_Subscriptions_UserId_DeviceToken] ON [pushnotificationservice].[Subscriptions] ([UserId], [DeviceToken]);
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20230102121140_PushNotificationServiceInit', N'7.0.1');
GO

COMMIT;
GO

