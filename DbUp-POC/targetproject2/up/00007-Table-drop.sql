USE [test];

IF NOT EXISTS(SELECT * FROM sys.objects WHERE name='TableToDrop-backup' AND type='U')
BEGIN
SELECT *
INTO [TableToDrop-backup]
FROM [TableToDrop]
END

DROP TABLE [TableToDrop]