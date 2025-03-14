USE [cabs_production]
GO

/****** Object:  StoredProcedure [dbo].[LicenceVL_Search]    Script Date: 5/14/2020 1:39:51 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*
	Andrew Snook
	Changes to search sp
*/

ALTER PROCEDURE [dbo].[LicenceVL_Search]
(
	@PlateNumber int,
	@RegistrationNumber varchar(10),
	@FirstName nvarchar(50),
	@LastName nvarchar(50),
	@Ccsn nvarchar(20),
	@Ppsn nvarchar(20),
	@Address nvarchar(100),
	@CountyId nvarchar(10),
	@PhoneNumber nvarchar(50),
	@PostCode nvarchar(12),
	@VehicleMakeId int,
	@VehicleModel nvarchar(25),
	@VehicleColour varchar(30),
	@CompanyName nvarchar(100),
	@LicenceTypeId int,
	@DateOfBirth date
)

AS

-- If all parameters are null, throw an error
-- A parameter must be provided.

if 
(
	@PlateNumber is null
	and @RegistrationNumber is null 
	and @FirstName is null 
	and @LastName is null 
	and @Ccsn is null 
	and @Ppsn is null
	and @Address is null
	and @CountyId is null
	and @PhoneNumber is null
	and @PostCode is null
	and	@VehicleMakeId is null
	and	@VehicleModel is null
	and @VehicleColour is null
	and	@CompanyName is null
	and	@LicenceTypeId  is null
	and	@DateOfBirth is null
)
BEGIN
	RAISERROR ('You must supply a search parameter.', 16, 1)
	RETURN
END

BEGIN


SET NOCOUNT ON;

SET @RegistrationNumber = REPLACE(@RegistrationNumber, '''', '')
SET @FirstName = REPLACE(@FirstName, '''', '')
SET @LastName = REPLACE(@LastName, '''', '''''')
SET @Ccsn = REPLACE(@Ccsn, '''', '')
SET @Ppsn = REPLACE(@Ppsn, '''', '')
SET @Address = REPLACE(@Address, '''', '')
SET @CountyId = REPLACE(@CountyId, '''', '')
SET @PhoneNumber = REPLACE(@PhoneNumber, '''', '')
SET @PostCode = REPLACE(@PostCode, '''', '')
SET @VehicleMakeId = REPLACE(@VehicleMakeId, '''', '')
SET @VehicleModel = REPLACE(@VehicleModel, '''', '')
SET @VehicleColour = REPLACE(@VehicleColour, '''', '')
SET @CompanyName = REPLACE(@CompanyName, '''', '')
SET @LicenceTypeId = REPLACE(@LicenceTypeId, '''', '')
SET @DateOfBirth = REPLACE(@DateOfBirth, '''', '')

	DECLARE @SearchSql nvarchar(4000)
	DECLARE @HolderName nvarchar(101)
	DECLARE @ParamDefin nvarchar(4000)
	
	IF 	@FirstName IS NOT NULL
	BEGIN
SET @HolderName = RTRIM(@FirstName)
	END	
		
	IF 	@LastName IS NOT NULL
	BEGIN
SET @HolderName = coalesce(@HolderName, '') + ' ' + LTRIM(@LastName)
	END

SET @HolderName = LTRIM(RTRIM(@HolderName))
SET @Address = LTRIM(RTRIM(@Address))


SET @ParamDefin = '@PlateNumber int,
						@RegistrationNumber varchar(10),
						@FirstName nvarchar(50),
						@LastName nvarchar(50),
						@Ccsn nvarchar(20),
						@Ppsn nvarchar(10),
						@Address nvarchar(50),
						@CountyId int,
						@PhoneNumber nvarchar(15),
						@PostCode nvarchar(10),
						@VehicleMakeId int,
						@VehicleModel nvarchar(25),
						@VehicleColour varchar(30),
						@CompanyName nvarchar(50),
						@LicenceTypeId int,
						@DateOfBirth datetime'

SET @SearchSql = 'SELECT	L.PlateNumber, L.LicenceNumber, 
						H.HolderName, H.FirstName, H.LastName, H.Ccsn, H.Ppsn, 
						L.RegistrationNumber, T.LicenceType, S.LicenceState, SM.LicenceStateMaster, 
						L.LicenceIssueDate, L.LicenceExpiryDate,H.AddressLine1, H.AddressLine2, 
						H.AddressLine3, H.Town, H.PostCode, H.CountyId, VMk.MakeId, VMd.Model, 
						VC.Colour, H.CompanyName, T.LicenceTypeId, H.DateOfBirth

						FROM LicenceMasterVL L

						LEFT OUTER JOIN dbo.LicenceHolderMaster H on H.LicenceHolderId = L.LicenceHolderId
						LEFT OUTER JOIN dbo.LicenceType T on T.LicenceTypeId = L.LicenceTypeId
						LEFT OUTER JOIN dbo.LicenceState S on S.LicenceStateId = L.LicenceStateId
						LEFT OUTER JOIN dbo.LicenceStateMaster SM on SM.LicenceStateMasterId = L.LicenceStateMasterId	
						LEFT OUTER JOIN dbo.VehicleMaster VM on VM.RegistrationNumber = L.RegistrationNumber						
						LEFT OUTER JOIN dbo.VehicleMake VMk on VMk.MakeId = VM.MakeId
						LEFT OUTER JOIN dbo.VehicleModel VMd on VMd.ModelId = VM.ModelId
						LEFT OUTER JOIN dbo.VehicleColour VC on VC.ColourId = VM.ColourId
						
						WHERE 1 = 1'
						
	IF 	@PlateNumber IS NOT NULL
	BEGIN
SET @SearchSql = @SearchSql + ' AND L.PlateNumber = ' + convert(NVARCHAR(10), @PlateNumber)
	END
	
	IF 	@RegistrationNumber IS NOT NULL
	BEGIN
SET @SearchSql = @SearchSql + ' AND L.RegistrationNumber = ''' + @RegistrationNumber + ''''
	END			

	IF 	@HolderName IS NOT NULL
	BEGIN
SET @SearchSql = @SearchSql + ' AND H.HolderName LIKE ''%' + @HolderName + '%'''
	END			
		
	IF 	@Ccsn IS NOT NULL
	BEGIN
SET @SearchSql = @SearchSql + ' AND H.Ccsn = ''' + @Ccsn + ''''
	END	
	
	IF 	@Ppsn IS NOT NULL
	BEGIN
SET @SearchSql = @SearchSql + ' AND H.Ppsn = ''' + @Ppsn + ''''
	END	
	
	IF 	@CountyId IS NOT NULL
	BEGIN
SET @SearchSql = @SearchSql + ' AND H.CountyId = ' + convert(NVARCHAR(10), @CountyId)
	END	
			
	IF 	@PhoneNumber IS NOT NULL
	BEGIN
SET @SearchSql = @SearchSql + ' AND '
SET @SearchSql = @SearchSql + ' ( '
SET @SearchSql = @SearchSql + '		H.PhoneNo1 = ''' + @PhoneNumber + ''''
SET @SearchSql = @SearchSql + '		OR H.PhoneNo2 = ''' + @PhoneNumber + ''''
SET @SearchSql = @SearchSql + ' ) '
	END	
	
	IF 	@Address IS NOT NULL
	BEGIN
SET @SearchSql = @SearchSql + ' AND '
SET @SearchSql = @SearchSql + ' ( '
SET @SearchSql = @SearchSql + '		H.AddressLine1 LIKE ''%' + @Address + '%'''
SET @SearchSql = @SearchSql + '		OR H.AddressLine2 LIKE ''%' + @Address + '%'''
SET @SearchSql = @SearchSql + '		OR H.AddressLine3 LIKE ''%' + @Address + '%'''
SET @SearchSql = @SearchSql + '		OR H.Town LIKE ''%' + @Address + '%'''
SET @SearchSql = @SearchSql + ' ) '
	END	
	
	IF 	@PostCode IS NOT NULL
	BEGIN
SET @SearchSql = @SearchSql + ' AND H.PostCode = ''' + @PostCode + ''''
	END	
		
	IF 	@VehicleMakeId IS NOT NULL
	BEGIN
SET @SearchSql = @SearchSql + ' AND VMk.MakeId = ' + convert(NVARCHAR(10), @VehicleMakeID)
	END	

	IF 	@VehicleModel IS NOT NULL
	BEGIN
SET @SearchSql = @SearchSql + ' AND VMd.Model LIKE ''%' + @VehicleModel + '%'''
	END	
	
	IF 	@VehicleColour IS NOT NULL
	BEGIN
SET @SearchSql = @SearchSql + ' AND VC.Colour LIKE ''%' + @VehicleColour + '%'''
	END	
	
	IF 	@CompanyName IS NOT NULL
	BEGIN
SET @SearchSql = @SearchSql + ' AND H.CompanyName LIKE ''%' + @CompanyName + '%'''
	END	
	
	IF 	@LicenceTypeId IS NOT NULL
	BEGIN
SET @SearchSql = @SearchSql + ' AND T.LicenceTypeId = ' + convert(NVARCHAR(10), @LicenceTypeId) 
	END	
	
	IF 	@DateOfBirth IS NOT NULL
	BEGIN
SET @SearchSql = @SearchSql + ' AND H.DateOfBirth = ''' + convert(VARCHAR, @DateOfBirth) + ''''
	END

EXEC sp_executesql @SearchSql,
@ParamDefin,
@PlateNumber = @PlateNumber,
@RegistrationNumber = @RegistrationNumber,
@FirstName = @FirstName,
@LastName = @LastName,
@Ccsn = @Ccsn,
@Ppsn = @Ppsn,
@Address = @Address,
@CountyId = @CountyId,
@PhoneNumber = @PhoneNumber,
@PostCode = @PostCode,
@VehicleMakeId = @VehicleMakeId,
@VehicleModel = @VehicleModel,
@VehicleColour = @VehicleColour,
@CompanyName = @CompanyName,
@LicenceTypeId = @LicenceTypeId,
@DateOfBirth = @DateOfBirth 
						

END
GO


