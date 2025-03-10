USE [cabs_production]
GO

/****** Object:  StoredProcedure [dbo].[LicenceHolderMasterAudit_Insert]    Script Date: 4/21/2020 1:32:00 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Andrew Snook>
-- Create date: <9/11/2010>
-- =============================================
ALTER PROCEDURE [dbo].[LicenceHolderMasterAudit_Insert]

	@LicenceHolderId int,
	@Ccsn nvarchar(10),
	@Ppsn varchar(10),
	@CompanyNumber int,
	@FirstName nvarchar(50),
	@LastName nvarchar(50),
	@DateOfBirth datetime,
	@CompanyName nvarchar(50),
	@TradingAs nvarchar(50),
	@AddressLine1 nvarchar(50),
	@AddressLine2 nvarchar(50),
	@AddressLine3 nvarchar(50),
	@Town nvarchar(50),
	@CountyId tinyint,
	@PostCode varchar(10),
	@CountryId smallint,
	@IrishLanguageAddress bit,
	@PhoneNo1 varchar(15),
	@PhoneNo2 varchar(15),
	@Email nvarchar(50),
	@EmailOptIn bit,
	@MailOptIn bit,
	@TaxClearanceNumber varchar(20),
	@TaxClearancecertExists bit,
	@TaxClearanceName nvarchar(100),
	@LastDocumentationCheckDate datetime = null,
	@HistoryChangeId int,	
	@CreatedBy nvarchar(50),	
	@CreatedDate datetime,	
	@ModifiedBy nvarchar(50),	
	@ModifiedDate datetime,
	@DeceasedYn bit,
	@Director1Name nvarchar(100),
	@Director2Name nvarchar(100),
	@Director3Name nvarchar(100),
	@Director1Address nvarchar(150),
	@Director2Address nvarchar(150),
	@Director3Address nvarchar(150)

	
AS
BEGIN
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;

INSERT
INTO
	LicenceHolderAudit
	(
	LicenceHolderId
  , Ccsn
  , Ppsn
  , CompanyNumber
  , FirstName
  , LastName
  , DateOfBirth
  , CompanyName
  , TradingAs
  , AddressLine1
  , AddressLine2
  , AddressLine3
  , Town
  , CountyId
  , PostCode
  , CountryID
  , IrishLanguageAddress
  , PhoneNo1
  , PhoneNo2
  , Email
  , EmailOptIn
  , MailOptIn
  , TaxClearanceNumber
  , TaxClearanceCertExists  
  , TaxClearanceName
  , LastDocumentationCheckDate
  , ChangeReasonId
  , CreatedBy
  , CreatedDate
  , ModifiedBy
  , ModifiedDate
  , AuditDate

	)

VALUES
	(
	@LicenceHolderId,
	@Ccsn,
	@Ppsn,
	@CompanyNumber,
	@FirstName,
	@LastName,
	@DateOfBirth,
	@CompanyName,
	@TradingAs,
	@AddressLine1,
	@AddressLine2,
	@AddressLine3,
	@Town,
	@CountyId,
	@PostCode,
	@CountryId,
	@IrishLanguageAddress,
	@PhoneNo1,
	@PhoneNo2,
	@Email,
	@EmailOptIn,
	@MailOptIn,
	@TaxClearanceNumber,
	@TaxClearanceCertExists,
	@TaxClearanceName,
	@LastDocumentationCheckDate,
	@HistoryChangeId,
	@CreatedBy,
	@CreatedDate,
	@ModifiedBy,
	@ModifiedDate,
	getdate()

	)
    -- Insert statements for procedure here

END

GO


