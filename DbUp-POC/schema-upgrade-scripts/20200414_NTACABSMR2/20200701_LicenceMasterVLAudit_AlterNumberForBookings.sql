USE [cabs_production]
GO

ALTER TABLE [dbo].[LicenceMasterVLAudit]
ALTER COLUMN [NumberForBookings] nvarchar(255) null
	