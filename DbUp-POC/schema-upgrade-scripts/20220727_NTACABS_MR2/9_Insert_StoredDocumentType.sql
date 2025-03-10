-- Please ensure that inserted values contains following IDs
-- TamperproofDiscsReturned = 2
-- VehicleLicenceCertificateReturned = 3
-- TamperproofDiscsReturnedVehicleLicenceCertificateReturned = 4

USE [cabs_production]
GO

INSERT INTO [dbo].[StoredDocumentType]
           ([Title]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[ModifiedBy]
           ,[ModifiedDate])
     VALUES
       ('TamperproofDiscsReturned','opensky',GETDATE(),NULL,NULL),
	   ('VehicleLicenceCertificateReturned','opensky',GETDATE(),NULL,NULL),
	   ('TamperproofDiscsReturnedVehicleLicenceCertificateReturned','opensky',GETDATE(),NULL,NULL)
GO


