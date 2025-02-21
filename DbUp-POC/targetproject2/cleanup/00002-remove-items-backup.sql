BEGIN

IF EXISTS (SELECT * FROM sys.objects WHERE name='Items-backup' AND type='U')
BEGIN
TRUNCATE TABLE [Items-backup]
DROP TABLE [Items-backup]
END

END