USE [cabs_production]
GO

/****** Object:  StoredProcedure [cabs_sk].[CreatePrintRequestMaster]    Script Date: 10/20/2020 3:22:43 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [cabs_sk].[CreatePrintRequestMaster]
	@PrintRequestReasonId tinyint,	
	@LetterRequestTypeId tinyint,	
	@PrintRequestStatusId tinyint,	
	@Ccsn varchar(20),	
	@LicenceNumber varchar(50),	
	@FirstName nvarchar(50),	
	@LastName nvarchar(50),	
	@DriverAddress1 nvarchar(100),
	@DriverAddress2 nvarchar(100),
	@DriverAddress3 nvarchar(100),
	@DriverCounty nvarchar(20),
	@DriverPostCode nvarchar(12),
	@DeliveryDestinationId tinyint,
	@ExpiryDate varchar(20),
	@LicenceHolderImage image,
	@CreatedBy nvarchar(20),
	@CreatedDate datetime
AS
BEGIN
	INSERT INTO [cabs_live].[dbo].[PrintRequestMaster]
	   (
		   [PrintRequestReasonId]
		   ,[LetterRequestTypeId]
		   ,[PrintRequestStatusId]
		   ,[Ccsn]
		   ,[LicenceNumber]
		   ,[FirstName]
		   ,[LastName]
		   ,[DriverAddress1]
		   ,[DriverAddress2]
		   ,[DriverAddress3]
		   ,[DriverCounty]
		   ,[DriverPostCode]
		   ,[DeliveryDestinationId]
		   ,[ExpiryDate]
		   ,[LicenceHolderImage]
		   ,[DespatchMethodId]
		   ,[DespatchDate]
		   ,[CreatedBy]
		   ,[CreatedDate]
	   )
	VALUES
	   (
			@PrintRequestReasonId,	
			@LetterRequestTypeId,	
			@PrintRequestStatusId,	
			@Ccsn,	
			@LicenceNumber,	
			@FirstName,	
			@LastName,	
			@DriverAddress1,
			@DriverAddress2,
			@DriverAddress3,
			@DriverCounty,
			@DriverPostCode,
			@DeliveryDestinationId,
			@ExpiryDate,
			@LicenceHolderImage,
			NULL,
			NULL,
			@CreatedBy,
			@CreatedDate
		)
	
	SELECT CAST(@@IDENTITY AS int) AS Column1
END
GO


