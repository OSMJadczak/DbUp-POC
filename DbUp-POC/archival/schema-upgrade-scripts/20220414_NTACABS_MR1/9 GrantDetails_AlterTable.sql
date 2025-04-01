USE [cabs_live]
GO

/****** Object:  Table [dbo].[GrantDetails]    Script Date: 10.06.2022 08:52:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER TABLE [dbo].[GrantDetails]  
	ALTER COLUMN [VehicleRegistrationNumber] [varchar](10) NULL
GO

ALTER TABLE [dbo].[GrantDetails]  
	ALTER COLUMN [ProposedVehicleTypeId] [int] NULL
GO

