USE [cabs_production]
GO

/****** Object:  StoredProcedure [dbo].[LicenceHolderMaster_Insert]    Script Date: 4/21/2020 1:50:26 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[LicenceHolderMaster_Insert] 
	-- Add the parameters for the stored procedure here
		(
		@LicenceHolderId int output,
		@Ccsn nvarchar(10) output,
		@Ppsn varchar(10),
		@FirstName nvarchar(50),
		@LastName nvarchar(50),
		@DateOfBirth datetime,
		@CompanyNumber int,
		@CompanyName nvarchar(50),
		@TradingAs nvarchar(50),
		@AddressLine1 nvarchar(50),
		@AddressLine2 nvarchar(50),
		@AddressLine3 nvarchar(50),
		@Town nvarchar(50),
		@CountyId tinyint,
		@PostCode nvarchar(10),
		@CountryId smallint,
		@IrishLanguageAddress bit,
		@PhoneNo1 varchar(40),
		@PhoneNo2 varchar(40),
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
		@ModifiedDate datetime output,
		@Director1Name nvarchar(100),
		@Director2Name nvarchar(100),
		@Director3Name nvarchar(100),
		@Director1Address nvarchar(150),
		@Director2Address nvarchar(150),
		@Director3Address nvarchar(150)
		)

AS
BEGIN
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;

SET @CreatedDate = GETDATE()
SET @ModifiedDate = @CreatedDate
SET @Ccsn = dbo.GetNextLicenceHolderCCSN(@FirstName, @LastName)

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
  , Director1Name
  , Director2Name
  , Director3Name
  , Director1Address
  , Director2Address
  , Director3Address
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
	@CreatedDate,
	@Director1Name,
	@Director2Name,
	@Director3Name,
	@Director1Address,
	@Director2Address,
	@Director3Address
	)

SET @LicenceHolderId = SCOPE_IDENTITY()
	
	
END

GO


