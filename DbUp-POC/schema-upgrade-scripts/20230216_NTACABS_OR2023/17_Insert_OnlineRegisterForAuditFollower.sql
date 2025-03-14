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

INSERT INTO [audit].[ProcessType](ProcessTypeId, Name) VALUES(63, 'Add Online Register User')
GO

INSERT INTO [audit].[ProcessType](ProcessTypeId, Name) VALUES(60, 'Update Online Register User')
GO

INSERT INTO [audit].[ProcessType](ProcessTypeId, Name) VALUES(61, 'Add Online Register Role')
GO

INSERT INTO [audit].[ProcessType](ProcessTypeId, Name) VALUES(62, 'Update Online Register Role')
GO

INSERT INTO [audit].[Module](ModuleId, Name) VALUES(8, 'OnlineRegister')
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20230517080652_IntegrateWithOnlineRegister', N'6.0.0');
GO

COMMIT;
GO

