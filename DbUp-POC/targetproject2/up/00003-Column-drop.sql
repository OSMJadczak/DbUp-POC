USE test;

IF NOT EXISTS(SELECT * FROM sys.objects WHERE name='TableToAdjust-backup' AND type='U')
BEGIN
SELECT * INTO [TableToAdjust-backup] FROM [TableToAdjust]
END

ALTER TABLE [TableToAdjust]
DROP COLUMN [ColumnToDrop]