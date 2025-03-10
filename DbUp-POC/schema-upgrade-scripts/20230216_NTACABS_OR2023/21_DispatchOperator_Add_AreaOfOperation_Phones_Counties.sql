BEGIN TRANSACTION;
GO

CREATE TABLE [do].[LicenceMasterCountiesOfOperation] (
    [CountyId] int NOT NULL,
    [LicenceId] int NOT NULL,
    CONSTRAINT [PK_LicenceMasterCountiesOfOperation] PRIMARY KEY ([CountyId], [LicenceId]),
    CONSTRAINT [FK_LicenceMasterCountiesOfOperation_CountyOfOperation_CountyId] FOREIGN KEY ([CountyId]) REFERENCES [do].[CountyOfOperation] ([Id]) ON DELETE NO ACTION,
    CONSTRAINT [FK_LicenceMasterCountiesOfOperation_LicenceMaster_LicenceId] FOREIGN KEY ([LicenceId]) REFERENCES [do].[LicenceMaster] ([Id]) ON DELETE NO ACTION
);
GO

CREATE INDEX [IX_LicenceMasterCountiesOfOperation_LicenceId] ON [do].[LicenceMasterCountiesOfOperation] ([LicenceId]);
GO

insert into do.LicenceMasterCountiesOfOperation(CountyId, LicenceId) select CountyId, Id as LicenceId from do.LicenceMaster;
GO

ALTER TABLE [do].[LicenceMaster] DROP CONSTRAINT [FK_LicenceMaster_CountyOfOperation_CountyId];
GO

DROP INDEX [IX_LicenceMaster_CountyId] ON [do].[LicenceMaster];
GO

DECLARE @var0 sysname;
SELECT @var0 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[do].[LicenceMaster]') AND [c].[name] = N'CountyId');
IF @var0 IS NOT NULL EXEC(N'ALTER TABLE [do].[LicenceMaster] DROP CONSTRAINT [' + @var0 + '];');
ALTER TABLE [do].[LicenceMaster] DROP COLUMN [CountyId];
GO

ALTER TABLE [do].[LicenceMaster] ADD [EmailForBookings] nvarchar(max) NULL;
GO

CREATE TABLE [do].[AreaOfOperation] (
    [Id] int NOT NULL IDENTITY,
    [LicenceId] int NOT NULL,
    [Area] nvarchar(max) NULL,
    CONSTRAINT [PK_AreaOfOperation] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_AreaOfOperation_LicenceMaster_LicenceId] FOREIGN KEY ([LicenceId]) REFERENCES [do].[LicenceMaster] ([Id]) ON DELETE NO ACTION
);
GO

CREATE TABLE [do].[Phone] (
    [Id] int NOT NULL IDENTITY,
    [LicenceId] int NOT NULL,
    [PhoneNumber] nvarchar(max) NULL,
    CONSTRAINT [PK_Phone] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_Phone_LicenceMaster_LicenceId] FOREIGN KEY ([LicenceId]) REFERENCES [do].[LicenceMaster] ([Id]) ON DELETE NO ACTION
);
GO

CREATE INDEX [IX_AreaOfOperation_LicenceId] ON [do].[AreaOfOperation] ([LicenceId]);
GO

CREATE INDEX [IX_Phone_LicenceId] ON [do].[Phone] ([LicenceId]);
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20230713115157_DispatchOperator_AddAreaOfOperation_AddPhones_AddListOfCountries', N'7.0.9');
GO



CREATE OR ALTER view [or].[vDispatchOperatorLicenceCountiesSearch]
as 
    select *  from  [do].[LicenceMasterCountiesOfOperation] lmcoo 
GO

COMMIT;
GO

