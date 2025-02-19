USE [test]

ALTER TABLE [TableToAdjust]
ADD [ColumnToDrop] BIT
GO

UPDATE original
SET original.ColumnToDrop = bkup.ColumnToDrop
FROM [TableToAdjust-backup] bkup
	INNER JOIN [TableToAdjust] original
	ON original.Id = bkup.Id

ALTER TABLE [TableToAdjust]
ALTER COLUMN [ColumnToDrop] BIT NOT NULL