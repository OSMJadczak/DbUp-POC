USE [cabs_production]
GO

/****** Object:  StoredProcedure [dbo].[TestCentre_Update]    Script Date: 2021-12-20 14:02:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		<Andrew Snook>
-- Create date: <29/10/2010>
-- Description:	<Edit a test centre>
-- =============================================
ALTER PROCEDURE [dbo].[TestCentre_Update] 
	-- Add the parameters for the stored procedure here
(
	@TestCentreId smallint,	
	@TestCentreName	varchar(50),	
	@RegionId tinyint,		
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
	@ModifiedBy nvarchar(20),
	@ModifiedDate datetime output,
	@CICapability bit
)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SET @ModifiedDate = GETDATE()

	UPDATE TestCentre
	SET		
		TestCentreName = @TestCentreName,
		RegionId = @RegionId,		
		AddressLine1 = @AddressLine1,	
		AddressLine2 = @AddressLine2,	
		AddressLine3 = @AddressLine3,	
		Town = @Town,
		CountyId = @CountyId,	
		PostCode = @PostCode,
		Eircode = @Eircode,
		CountryId = @CountryId,
		ContactName = @ContactName,
		ContactNumberPrimary = @ContactNumberPrimary,
		ContactNumberSecondary = @ContactNumberSecondary,
		Email = @Email,
		Active = @Active,
		ModifiedBy = @ModifiedBy,
		ModifiedDate = @ModifiedDate,
		CICapability = @CICapability
	WHERE 
		TestCentreId = @TestCentreId


    -- Insert statements for procedure here
	
END

GO


