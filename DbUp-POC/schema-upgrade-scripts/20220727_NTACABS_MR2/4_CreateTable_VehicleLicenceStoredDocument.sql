USE [cabs_production]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].VehicleLicenceStoredDocument(
	[VehicleLicenceStoredDocumentId] INT IDENTITY(1,1) NOT NULL,
	[StoredDocumentId] [int] NOT NULL,
	[LicenceNumber] varchar(50) NOT NULL,
	PRIMARY KEY (VehicleLicenceStoredDocumentId)
 )
GO

ALTER TABLE [dbo].[VehicleLicenceStoredDocument]  WITH CHECK ADD  CONSTRAINT [FK_VehicleLicenceStoredDocument_StoredDocument] FOREIGN KEY([StoredDocumentId])
REFERENCES [dbo].[StoredDocument] ([StoredDocumentId])
GO

ALTER TABLE [dbo].[VehicleLicenceStoredDocument]  WITH CHECK ADD  CONSTRAINT [FK_VehicleLicenceStoredDocument_LicenceMasterVL] FOREIGN KEY([LicenceNumber])
REFERENCES [dbo].[LicenceMasterVL] ([LicenceNumber])
GO
