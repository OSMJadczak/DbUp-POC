USE [cabs_production]
GO

/****** Object:  StoredProcedure [dbo].[TestCentre_Insert]    Script Date: 2021-12-20 13:36:34 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		<Andrew Snook>
-- Create date: <29/10/2010>
-- Description:	<Add a test centre>
-- =============================================
ALTER PROCEDURE [dbo].[TestCentre_Insert] 
	-- Add the parameters for the stored procedure here
(
	@TestCentreId smallint output,
	@TestCentreName	varchar(50),	
	@RegionId tinyint,	
	@CompanyId smallint,	
	@AddressLine1 nvarchar(50),	
	@AddressLine2 nvarchar(50),	
	@AddressLine3 nvarchar(50),	
	@Town nvarchar(50),	
	@CountyId tinyint,	
	@PostCode varchar(10),	
	@Eircode varchar(7),	
	@CountryId smallint,	
	@ContactName	nvarchar(50),	
	@ContactNumberPrimary varchar(15),	
	@ContactNumberSecondary varchar(15),
	@Email nvarchar(30),	
	@Active bit,
	@CreatedBy nvarchar(50),	
	@CreatedDate datetime output,	
	@ModifiedBy nvarchar(50),	
	@ModifiedDate datetime output,
	@CICapability bit
	
)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SET @CreatedDate = GETDATE()
	SET @ModifiedDate = @CreatedDate

	INSERT INTO TestCentre
	(
		TestCentreName,
		RegionId,
		CompanyId,	
		AddressLine1,	
		AddressLine2,	
		AddressLine3,	
		Town,
		CountyId,
		PostCode,
		Eircode,
		CountryId,
		ContactName,
		ContactNumberPrimary,
		ContactNumberSecondary,
		Email,
		Active,
		CreatedBy,
		ModifiedBy,
		CreatedDate,
		ModifiedDate,
		CICapability
	)
	VALUES
	(
		
		@TestCentreName,	
		@RegionId,	
		@CompanyId,	
		@AddressLine1,	
		@AddressLine2,	
		@AddressLine3,	
		@Town,	
		@CountyId,	
		@PostCode,
		@Eircode,
		@CountryId,	
		@ContactName,	
		@ContactNumberPrimary,	
		@ContactNumberSecondary,
		@Email,	
		@Active,
		@CreatedBy,
		@ModifiedBy,
		@CreatedDate,
		@ModifiedDate,
		@CICapability
	)

 	set @TestCentreId = SCOPE_IDENTITY()
	
END

GO


