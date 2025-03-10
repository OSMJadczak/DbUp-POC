BEGIN TRANSACTION;
GO

DROP TABLE [CABS_ENF].[FineNotifications];
GO

CREATE TABLE [CABS_ENF].[PendingProsecutionFines] (
    [Id] int NOT NULL IDENTITY,
    [FineId] int NOT NULL,
    [CaseWasCreated] bit NOT NULL,
    [CreatedBy] nvarchar(256) NULL,
    [CreatedDate] datetime2 NOT NULL,
    CONSTRAINT [PK_PendingProsecutionFines] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_PendingProsecutionFines_Fines_FineId] FOREIGN KEY ([FineId]) REFERENCES [CABS_ENF].[Fines] ([Id]) ON DELETE NO ACTION
);
GO

CREATE INDEX [IX_PendingProsecutionFines_FineId] ON [CABS_ENF].[PendingProsecutionFines] ([FineId]);
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20240611134040_AddPendingProsecution', N'6.0.0');
GO

COMMIT;
GO

