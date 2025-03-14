USE [cabs_production]
GO

BEGIN TRANSACTION;
GO

ALTER TABLE [CABS_ENF].[Fines] ADD [FineCreationType] int NULL;
GO

UPDATE [cabs_enf].[Fines] Set FineCreationType = 1 where FineCreationType is null
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20230912081804_AddFineCreationType', N'6.0.0');
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

CREATE TABLE [CABS_ENF].[FineNote] (
    [Id] int NOT NULL IDENTITY,
    [NoteContent] nvarchar(200) NOT NULL,
    [FineId] int NOT NULL,
    [CreatedBy] nvarchar(256) NULL,
    [CreatedDate] datetime NOT NULL DEFAULT (GETDATE()),
    CONSTRAINT [PK_FineNote] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_FineNote_Fines_FineId] FOREIGN KEY ([FineId]) REFERENCES [CABS_ENF].[Fines] ([Id]) ON DELETE NO ACTION
);
GO

CREATE INDEX [IX_FineNote_FineId] ON [CABS_ENF].[FineNote] ([FineId]);
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20230912120505_Enforcement.AddFineNotes', N'6.0.0');
GO

COMMIT;
GO

