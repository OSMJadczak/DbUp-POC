use Cabs_Live
go

DROP TABLE dbo.GrantStatus
GO

ALTER TABLE [dbo].GrantDetails ADD 
	StatusChangedDate [datetime] NULL
GO

ALTER TABLE [dbo].GrantDetails
ALTER COLUMN StatusId [int] NOT NULL
GO