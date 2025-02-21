BEGIN

IF EXISTS(SELECT * FROM sys.objects WHERE name='TableToAdjust-backup' AND type='U')
BEGIN
TRUNCATE TABLE [TableToAdjust-backup]
DROP TABLE [TableToAdjust-backup]
END

END