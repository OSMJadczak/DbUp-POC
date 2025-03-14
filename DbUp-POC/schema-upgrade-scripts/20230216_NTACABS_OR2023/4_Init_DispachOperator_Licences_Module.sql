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

IF SCHEMA_ID(N'do') IS NULL EXEC(N'CREATE SCHEMA [do];');
GO

CREATE TABLE [do].[CountyOfOperator] (
    [Id] int NOT NULL,
    [Name] nvarchar(64) NOT NULL,
    [CreatedDate] datetime2 NOT NULL,
    [CreatedBy] nvarchar(256) NOT NULL,
    [ModifiedDate] datetime2 NULL,
    [ModifiedBy] nvarchar(256) NULL,
    CONSTRAINT [PK_CountyOfOperator] PRIMARY KEY ([Id])
);
GO

CREATE TABLE [do].[LicenceStateMaster] (
    [Id] int NOT NULL,
    [Name] nvarchar(256) NOT NULL,
    [CreatedDate] datetime2 NOT NULL,
    [CreatedBy] nvarchar(256) NOT NULL,
    [ModifiedDate] datetime2 NULL,
    [ModifiedBy] nvarchar(256) NULL,
    CONSTRAINT [PK_LicenceStateMaster] PRIMARY KEY ([Id])
);
GO

CREATE TABLE [do].[LicenceState] (
    [Id] int NOT NULL,
    [Name] nvarchar(256) NOT NULL,
    [LicenceStateMasterId] int NOT NULL,
    [CreatedDate] datetime2 NOT NULL,
    [CreatedBy] nvarchar(256) NOT NULL,
    [ModifiedDate] datetime2 NULL,
    [ModifiedBy] nvarchar(256) NULL,
    CONSTRAINT [PK_LicenceState] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_LicenceState_LicenceStateMaster_LicenceStateMasterId] FOREIGN KEY ([LicenceStateMasterId]) REFERENCES [do].[LicenceStateMaster] ([Id]) ON DELETE CASCADE
);
GO

CREATE TABLE [do].[LicenceMaster] (
    [Id] int NOT NULL IDENTITY,
    [CountyId] int NOT NULL,
    [LicenceNumber] nvarchar(20) NOT NULL,
    [LicenceStateMasterId] int NOT NULL,
    [LicenceStateId] int NULL,
    [IssueDate] datetime2 NOT NULL,
    [ExpiryDate] datetime2 NOT NULL,
    [Website] nvarchar(max) NULL,
    [BookingApplication] nvarchar(max) NULL,
    [CreatedDate] datetime2 NOT NULL,
    [CreatedBy] nvarchar(256) NOT NULL,
    [ModifiedDate] datetime2 NULL,
    [ModifiedBy] nvarchar(256) NULL,
    CONSTRAINT [PK_LicenceMaster] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_LicenceMaster_CountyOfOperator_CountyId] FOREIGN KEY ([CountyId]) REFERENCES [do].[CountyOfOperator] ([Id]) ON DELETE NO ACTION,
    CONSTRAINT [FK_LicenceMaster_LicenceStateMaster_LicenceStateMasterId] FOREIGN KEY ([LicenceStateMasterId]) REFERENCES [do].[LicenceStateMaster] ([Id]) ON DELETE NO ACTION,
    CONSTRAINT [FK_LicenceMaster_LicenceState_LicenceStateId] FOREIGN KEY ([LicenceStateId]) REFERENCES [do].[LicenceState] ([Id]) ON DELETE NO ACTION
);
GO

CREATE TABLE [do].[LicenceHolderMaster] (
    [Id] int NOT NULL IDENTITY,
    [LicenceId] int NOT NULL,
    [PersonId] int NOT NULL,
    CONSTRAINT [PK_LicenceHolderMaster] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_LicenceHolderMaster_LicenceMaster_LicenceId] FOREIGN KEY ([LicenceId]) REFERENCES [do].[LicenceMaster] ([Id]) ON DELETE NO ACTION
);
GO

CREATE UNIQUE INDEX [IX_LicenceHolderMaster_LicenceId] ON [do].[LicenceHolderMaster] ([LicenceId]);
GO

CREATE INDEX [IX_LicenceMaster_CountyId] ON [do].[LicenceMaster] ([CountyId]);
GO

CREATE INDEX [IX_LicenceMaster_LicenceStateId] ON [do].[LicenceMaster] ([LicenceStateId]);
GO

CREATE INDEX [IX_LicenceMaster_LicenceStateMasterId] ON [do].[LicenceMaster] ([LicenceStateMasterId]);
GO

CREATE INDEX [IX_LicenceState_LicenceStateMasterId] ON [do].[LicenceState] ([LicenceStateMasterId]);
GO

INSERT INTO [do].[LicenceStateMaster]([Id],[Name],[CreatedBy],[CreatedDate]) VALUES (1,'Active','System',GETDATE())
GO

INSERT INTO [do].[LicenceStateMaster]([Id],[Name],[CreatedBy],[CreatedDate]) VALUES (2,'Inactive','System',GETDATE())
GO

INSERT INTO [do].[LicenceStateMaster]([Id],[Name],[CreatedBy],[CreatedDate]) VALUES (3,'Dead','System',GETDATE())
GO

INSERT INTO [do].[LicenceState]([Id],[LicenceStateMasterId],[Name],[CreatedBy],[CreatedDate]) VALUES (1,2,'Expired','System',GETDATE())
GO

INSERT INTO [do].[LicenceState]([Id],[LicenceStateMasterId],[Name],[CreatedBy],[CreatedDate]) VALUES (2,2,'Suspended','System',GETDATE())
GO

INSERT INTO [do].[LicenceState]([Id],[LicenceStateMasterId],[Name],[CreatedBy],[CreatedDate]) VALUES (3,3,'Surrendered','System',GETDATE())
GO

INSERT INTO [do].[LicenceState]([Id],[LicenceStateMasterId],[Name],[CreatedBy],[CreatedDate]) VALUES (4,3,'Revoked','System',GETDATE())
GO

INSERT INTO [do].[LicenceState]([Id],[LicenceStateMasterId],[Name],[CreatedBy],[CreatedDate]) VALUES (5,3,'Timed Out','System',GETDATE())
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20230316093452_DispatchOperator_InitialDbStruct', N'7.0.3');
GO

COMMIT;
GO

