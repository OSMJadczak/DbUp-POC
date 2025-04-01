USE [cabs_live]
GO

/****** Object:  Table [dbo].[Cases]    Script Date: 23.05.2022 12:46:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER TABLE [dbo].[Cases] ADD 
	[raisedby_dateofbirth] [date] NULL,
	[raisedby_tradingas] [nvarchar](100) NULL
GO

