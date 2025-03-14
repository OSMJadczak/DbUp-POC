BEGIN TRANSACTION;
GO

DROP TABLE [CABS_ENF].[PendingProsecutionFines];
GO

CREATE TABLE [CABS_ENF].[FineNotifications] (
    [Id] int NOT NULL IDENTITY,
    [FineId] int NOT NULL,
    [CreatedBy] nvarchar(256) NULL,
    [CreatedDate] datetime NULL,
    [EmailId] uniqueidentifier NULL,
    [ModifiedBy] nvarchar(256) NULL,
    [ModifiedDate] datetime NULL,
    [Sended] bit NOT NULL,
    CONSTRAINT [PK_FineNotifications] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_FineNotifications_Fines_FineId] FOREIGN KEY ([FineId]) REFERENCES [CABS_ENF].[Fines] ([Id]) ON DELETE NO ACTION
);
GO

CREATE INDEX [IX_FineNotifications_FineId] ON [CABS_ENF].[FineNotifications] ([FineId]);
GO

DELETE FROM [__EFMigrationsHistory]
WHERE [MigrationId] = N'20240611134040_AddPendingProsecution';
GO

COMMIT;
GO


-------------------------------------------
-- load data from backup table
-------------------------------------------
SET IDENTITY_INSERT FineNotifications ON;
TRUNCATE TABLE FineNotifications
insert into FineNotifications
(
    [Id]
    ,[FineId]
    ,[EmailId]
    ,[Sended]
    ,[CreatedBy]
    ,[CreatedDate]
    ,[ModifiedBy]
    ,[ModifiedDate]
)
select 
    [Id]
    ,[FineId]
    ,[EmailId]
    ,[Sended]
    ,[CreatedBy]
    ,[CreatedDate]
    ,[ModifiedBy]
    ,[ModifiedDate]

from tmp_FineNotifications


SET IDENTITY_INSERT FineNotifications OFF;

GO


