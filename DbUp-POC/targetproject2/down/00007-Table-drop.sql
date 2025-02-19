USE test;

/* IRL Migration script will have constraints created on migration */
SELECT *
INTO [TableToDrop]
FROM [TableToDrop-backup]