USE [cabs_production]
GO

BEGIN TRANSACTION;
GO

DROP TABLE [letters].[LetterDetail];
GO

DROP TABLE [letters].[LetterStatus];
GO

DROP TABLE [letters].[Letter];
GO

DROP TABLE [letters].[LetterDespatchMethod];
GO

DELETE FROM [__EFMigrationsHistory]
WHERE [MigrationId] = N'20230922064516_Init_LetterService';
GO

COMMIT;
GO
