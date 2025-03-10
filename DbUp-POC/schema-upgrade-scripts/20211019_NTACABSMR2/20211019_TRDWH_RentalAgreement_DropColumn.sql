USE [TRDWH]
GO

/****** Object:  Table [dbo].[DWH_RentalAgreement]    Script Date: 10/19/2021 11:54:29 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER TABLE [dbo].[DWH_RentalAgreement]
DROP COLUMN Address

ALTER TABLE [dbo].[Temp_DWH_RentalAgreement]
DROP COLUMN Address

