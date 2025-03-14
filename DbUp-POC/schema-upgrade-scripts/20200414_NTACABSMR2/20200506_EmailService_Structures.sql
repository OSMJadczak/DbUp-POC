IF OBJECT_ID(N'[__EFMigrationsHistory]') IS NULL
BEGIN
    CREATE TABLE [__EFMigrationsHistory] (
        [MigrationId] nvarchar(150) NOT NULL,
        [ProductVersion] nvarchar(32) NOT NULL,
        CONSTRAINT [PK___EFMigrationsHistory] PRIMARY KEY ([MigrationId])
    );
END;

GO

IF SCHEMA_ID(N'emailservice') IS NULL EXEC(N'CREATE SCHEMA [emailservice];');

GO

CREATE TABLE [emailservice].[EmailMessages] (
    [Id] uniqueidentifier NOT NULL,
    [EmailStatus] nvarchar(255) NOT NULL,
    [FromAddress] nvarchar(255) NOT NULL,
    [FromName] nvarchar(255) NOT NULL,
    [Subject] nvarchar(1000) NOT NULL,
    [Content] nvarchar(max) NULL,
    [IsHtmlBody] bit NOT NULL,
    [CreatedDate] datetime2 NOT NULL,
    [ModifiedDate] datetime2 NULL,
    CONSTRAINT [PK_EmailMessages] PRIMARY KEY ([Id])
);

GO

CREATE TABLE [emailservice].[EmailAddressCc] (
    [Id] bigint NOT NULL IDENTITY,
    [Name] nvarchar(255) NOT NULL,
    [Address] nvarchar(255) NOT NULL,
    [EmailMessageId] uniqueidentifier NOT NULL,
    CONSTRAINT [PK_EmailAddressCc] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_EmailAddressCc_EmailMessages_EmailMessageId] FOREIGN KEY ([EmailMessageId]) REFERENCES [emailservice].[EmailMessages] ([Id]) ON DELETE NO ACTION
);

GO

CREATE TABLE [emailservice].[EmailAddressTo] (
    [Id] bigint NOT NULL IDENTITY,
    [Name] nvarchar(255) NOT NULL,
    [Address] nvarchar(255) NOT NULL,
    [EmailMessageId] uniqueidentifier NOT NULL,
    CONSTRAINT [PK_EmailAddressTo] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_EmailAddressTo_EmailMessages_EmailMessageId] FOREIGN KEY ([EmailMessageId]) REFERENCES [emailservice].[EmailMessages] ([Id]) ON DELETE NO ACTION
);

GO

CREATE TABLE [emailservice].[EmailAttachments] (
    [Id] uniqueidentifier NOT NULL,
    [Name] nvarchar(255) NOT NULL,
    [Content] varbinary(max) NULL,
    [EmailMessageId] uniqueidentifier NOT NULL,
    CONSTRAINT [PK_EmailAttachments] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_EmailAttachments_EmailMessages_EmailMessageId] FOREIGN KEY ([EmailMessageId]) REFERENCES [emailservice].[EmailMessages] ([Id]) ON DELETE NO ACTION
);

GO

CREATE INDEX [IX_EmailAddressCc_EmailMessageId] ON [emailservice].[EmailAddressCc] ([EmailMessageId]);

GO

CREATE INDEX [IX_EmailAddressTo_EmailMessageId] ON [emailservice].[EmailAddressTo] ([EmailMessageId]);

GO

CREATE INDEX [IX_EmailAttachments_EmailMessageId] ON [emailservice].[EmailAttachments] ([EmailMessageId]);

GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20200430080102_EmailService.Initial', N'3.1.3');

GO

