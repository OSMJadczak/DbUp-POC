USE [cabs_production]
GO

/****** Object:  StoredProcedure [dbo].[LicenceHolderMaster_Insert]    Script Date: 2022-04-26 15:58:50 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[LicenceHolderMaster_Insert] 
	-- Add the parameters for the stored procedure here
		(
		@LicenceHolderId int output,
		@Ccsn nvarchar(20),
		@Ppsn varchar(20),
		@FirstName nvarchar(50),
		@LastName nvarchar(50),
		@DateOfBirth datetime,
		@CompanyNumber int,
		@CompanyName nvarchar(100),
		@TradingAs nvarchar(100),
		@AddressLine1 nvarchar(100),
		@AddressLine2 nvarchar(100),
		@AddressLine3 nvarchar(100),
		@Town nvarchar(50),
		@CountyId tinyint,
		@PostCode nvarchar(12),
		@CountryId smallint,
		@IrishLanguageAddress bit,
		@PhoneNo1 varchar(50),
		@PhoneNo2 varchar(50),
		@Email nvarchar(50),
		@EmailOptIn bit,
		@MailOptIn bit,
		@TaxClearanceNumber varchar(20),
		@TaxClearanceCertExists bit,
		@TaxClearanceName nvarchar(100),	
		@LastDocumentationCheckDate datetime,
		@DeceasedYn bit,
		@CreatedBy nvarchar(50),	
		@CreatedDate datetime output,	
		@ModifiedBy nvarchar(50),	
		@ModifiedDate datetime output
		)

AS
BEGIN
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;

SET @CreatedDate = GETDATE()
SET @ModifiedDate = @CreatedDate

INSERT
INTO
	LicenceHolderMaster
	(
	Ccsn
  , Ppsn
  , FirstName
  , LastName
  , DateOfBirth
  , CompanyNumber
  , CompanyName
  , TradingAs
  , AddressLine1
  , AddressLine2
  , AddressLine3
  , Town
  , CountyId
  , IrishLanguageAddress
  , PostCode
  , CountryId
  , PhoneNo1
  , PhoneNo2
  , Email
  , EmailOptIn
  , MailOptIn
  , TaxClearanceNumber
  , TaxClearanceCertExists
  , TaxClearanceName
  , LastDocumentationCheckDate
  , DeceasedYn
  , CreatedBy
  , ModifiedBy
  , ModifiedDate
  , CreatedDate
	)

VALUES
	(
	@Ccsn,
	@Ppsn,
	@FirstName,
	@LastName,
	@DateOfBirth,
	@CompanyNumber,
	@CompanyName,
	@TradingAs,
	@AddressLine1,
	@AddressLine2,
	@AddressLine3,
	@Town,
	@CountyId,
	@IrishLanguageAddress,
	@PostCode,
	@CountryId,
	@PhoneNo1,
	@PhoneNo2,
	@Email,
	@EmailOptIn,
	@MailOptIn,
	@TaxClearanceNumber,
	@TaxClearanceCertExists,	
	@TaxClearanceName,
	@LastDocumentationCheckDate,
	@DeceasedYn,
	@CreatedBy,
	@ModifiedBy,
	@ModifiedDate,
	@CreatedDate
	)

SET @LicenceHolderId = SCOPE_IDENTITY()
	
	
END

GO


