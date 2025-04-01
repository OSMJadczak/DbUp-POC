USE [cabs_production]
GO

ALTER TABLE dbo.TestCentre
ALTER COLUMN AddressLine1 nvarchar(50)

ALTER TABLE dbo.TestCentre
ALTER COLUMN AddressLine2 nvarchar(50)

ALTER TABLE dbo.TestCentre
ALTER COLUMN AddressLine3 nvarchar(50)

ALTER TABLE dbo.TestCentre
ALTER COLUMN Town nvarchar(50)

ALTER TABLE dbo.TestCentre
DROP COLUMN ContactNumberFax

ALTER TABLE dbo.TestCentre
ADD Eircode VARCHAR(7)
