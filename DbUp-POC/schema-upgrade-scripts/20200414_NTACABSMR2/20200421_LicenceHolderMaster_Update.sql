USE [cabs_production]
GO

/****** Object:  StoredProcedure [dbo].[LicenceHolderMaster_Update]    Script Date: 4/21/2020 1:29:53 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[LicenceHolderMaster_Update] 

(
		@LicenceHolderId int,
		@Ccsn nvarchar(10),
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
		@CountryId tinyint,
		@IrishLanguageAddress bit,
		@PhoneNo1 varchar(15),
		@PhoneNo2 varchar(15),
		@Email nvarchar(50),
		@EmailOptIn bit,
		@MailOptIn bit,
		@TaxClearanceNumber varchar(20),
		@TaxClearanceCertExists bit,	
		@TaxClearanceName nvarchar(100),
		@LastDocumentationCheckDate datetime,
		@DeceasedYn bit,
		@ModifiedBy nvarchar(20),
		@ModifiedDate datetime output,
		@CreatedBy nvarchar(20),
		@CreatedDate datetime,
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

-- Insert statements for procedure here

SET @ModifiedDate = GETDATE()

UPDATE LicenceHolderMaster

SET
	Ccsn = @Ccsn,
	Ppsn = @Ppsn,
	FirstName = @FirstName,
	LastName = @LastName,
	DateOfBirth = @DateOfBirth,
	CompanyNumber = @CompanyNumber,
	CompanyName = @CompanyName,
	TradingAs = @TradingAs,
	AddressLine1 = @AddressLine1,
	AddressLine2 = @AddressLine2,
	AddressLine3 = @AddressLine3,
	Town = @Town,
	CountyId = @CountyId,
	IrishLanguageAddress = @IrishLanguageAddress,
	PostCode = @PostCode,
	CountryId = @CountryId,
	PhoneNo1 = @PhoneNo1,
	PhoneNo2 = @PhoneNo2,
	Email = @Email,
	EmailOptIn = @EmailOptIn,
	MailOptIn = @MailOptIn,
	TaxClearanceNumber = @TaxClearanceNumber,
	TaxClearanceCertExists = @TaxClearanceCertExists,	
	TaxClearanceName = @TaxClearanceName,
	LastDocumentationCheckDate = @LastDocumentationCheckDate,
	DeceasedYn = @DeceasedYn,
	ModifiedBy = @ModifiedBy,
	ModifiedDate = @ModifiedDate,
	Director1Name = @Director1Name,
	Director2Name = @Director2Name,
	Director3Name = @Director3Name,
	Director1Address = @Director1Address,
	Director2Address = @Director2Address,
	Director3Address = @Director3Address

WHERE
	LicenceHolderId = @LicenceHolderId


END

GO


