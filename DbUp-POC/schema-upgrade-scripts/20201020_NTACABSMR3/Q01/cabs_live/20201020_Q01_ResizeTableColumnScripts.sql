USE [Cabs_Live]
GO

ALTER TABLE [dbo].[Cases]
	ALTER COLUMN [raisedby_address] [nvarchar](450) NULL
	
ALTER TABLE [dbo].[Case_History]
	ALTER COLUMN [oldValue] [nvarchar](max) NULL