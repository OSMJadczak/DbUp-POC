USE [cabs_production]
GO

/****** Object:  Table [cabs_enf].[SearchAudit]    Script Date: 2023-07-11 15:05:26 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER TABLE [cabs_enf].[SearchAudit] ADD
	ManualLinkDL varchar(10) NULL,
	ManualLinkVL varchar(10) NULL
GO

ALTER TABLE [cabs_enf].[Audit] ADD
	ManualLinkDL varchar(10) NULL,
	ManualLinkVL varchar(10) NULL
GO