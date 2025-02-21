BEGIN

IF EXISTS(SELECT * FROM sys.objects WHERE name='TableToDrop-backup' AND type='U')
BEGIN
TRUNCATE TABLE [TableToDrop-backup]
DROP TABLE [TableToDrop-backup]
END

END