USE test;

SELECT * INTO [TableToAdjust-backup] FROM [TableToAdjust]

ALTER TABLE [TableToAdjust]
DROP COLUMN [ColumnToDrop]