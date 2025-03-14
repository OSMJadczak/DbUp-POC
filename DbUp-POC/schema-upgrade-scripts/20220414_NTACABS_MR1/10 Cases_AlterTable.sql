USE [cabs_live]
GO

/****** Object:  Table [dbo].[Cases]    Script Date: 23.05.2022 12:46:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER TABLE [dbo].[Cases] ADD 
	[raisedby_address2] [nvarchar](100) NULL,
	[raisedby_address3] [nvarchar](100) NULL,
	[raisedby_town] [nvarchar](50) NULL,
	[raisedby_postcode] [varchar](12) NULL,
	[raisedby_eircode] [nvarchar](20) NULL,
	[raisedby_country] [varchar](50) NULL,
	[raisedby_ppsn] [varchar](20) NULL,
	[raisedby_companyname] [nvarchar](100) NULL,
	[raisedby_persontype] [varchar](20) NULL
GO

