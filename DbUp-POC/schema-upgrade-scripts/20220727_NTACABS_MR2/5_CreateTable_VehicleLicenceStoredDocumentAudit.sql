USE [cabs_production]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].VehicleLicenceStoredDocumentAudit(
	[VehicleLicenceStoredDocumentAuditId] INT IDENTITY(1,1) NOT NULL,
	[VehicleLicenceStoredDocumentId] [int] NOT NULL,
	[StoredDocumentId] [int] NOT NULL,
	[LicenceNumber] varchar(50) NOT NULL,
	[StoredDocumentTypeId] [int] NOT NULL,
	[FileName] varchar(255) NOT NULL,
	[Title] varchar(255) NOT NULL,
	[FileContentChanged] bit NOT NULL,
	[CreatedBy] varchar(255) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedBy] varchar(255) NULL,
	[ModifiedDate] [datetime] NULL,
	PRIMARY KEY (VehicleLicenceStoredDocumentAuditId)
 )
 GO

ALTER TABLE [dbo].[VehicleLicenceStoredDocumentAudit]  WITH CHECK ADD  CONSTRAINT [FK_VehicleLicenceStoredDocumentAudit_VehicleLicenceStoredDocument] FOREIGN KEY([VehicleLicenceStoredDocumentId])
REFERENCES [dbo].[VehicleLicenceStoredDocument] ([VehicleLicenceStoredDocumentId])
GO