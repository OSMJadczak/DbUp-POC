CREATE TABLE [CABS_ENF].[FineNotifications] (
    [Id] int NOT NULL IDENTITY,
    [FineId] int NOT NULL,
    [EmailId] uniqueidentifier NULL,
    [Sended] bit NOT NULL,
    [CreatedBy] nvarchar(256) NULL,
    [CreatedDate] datetime NULL,
    [ModifiedBy] nvarchar(256) NULL,
    [ModifiedDate] datetime NULL,
    CONSTRAINT [PK_FineNotifications] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_FineNotifications_Fines_FineId] FOREIGN KEY ([FineId]) REFERENCES [CABS_ENF].[Fines] ([Id]) ON DELETE NO ACTION
);

GO

CREATE INDEX [IX_FineNotifications_FineId] ON [CABS_ENF].[FineNotifications] ([FineId]);

GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20200422113542_Enforcement.AddFineNotification', N'2.2.2-servicing-10034');

GO

