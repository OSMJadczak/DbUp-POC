IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='Items' AND COLUMN_NAME='NewColumn')

ALTER TABLE [Items] DROP COLUMN [NewColumn]