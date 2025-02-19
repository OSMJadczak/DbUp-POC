USE test;

ALTER TABLE [Items]
DROP CONSTRAINT [DF_Constraint]

ALTER TABLE [Items]
ALTER COLUMN [ColumnToChangeDatatype] VARCHAR(100)

UPDATE original
SET original.[ColumnToChangeDatatype] = bkup.[ColumnToChangeDatatype]
FROM [Items-backup] bkup
	INNER JOIN [Items] original
	ON original.Id = bkup.Id