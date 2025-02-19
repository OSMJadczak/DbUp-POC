USE [test];

SELECT *
INTO [TableToDrop-backup]
FROM [TableToDrop]

DROP TABLE [TableToDrop]