IF NOT EXISTS (SELECT * FROM sys.objects WHERE name = 'Items-backup' AND type='U')
SELECT *
INTO [Items-backup]
FROM [Items]
GO

UPDATE [Items] SET [ColumnToChangeDatatype] = 0

ALTER TABLE [Items]
ALTER COLUMN [ColumnToChangeDatatype] BIT NOT NULL

ALTER TABLE [Items] ADD CONSTRAINT DF_Constraint DEFAULT 0 FOR ColumnToChangeDatatype;