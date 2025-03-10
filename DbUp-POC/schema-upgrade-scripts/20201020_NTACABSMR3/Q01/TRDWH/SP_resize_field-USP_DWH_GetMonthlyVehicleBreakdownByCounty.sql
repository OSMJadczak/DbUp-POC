USE [TRDWH]
GO

/****** Object:  StoredProcedure [dbo].[USP_DWH_GetMonthlyVehicleBreakdownByCounty]    Script Date: 5/14/2020 4:02:30 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*
=============================================
-- Author:		Robert Hamilton
-- Create date: 15-Jul-2009
-- Description:	Returns all possible Status codes present in status table

Exec USP_DWH_GetMonthlyVehicleBreakdownByCounty 'ACTIVE', 'Jul 09', 'CARLOW'

=============================================
*/
ALTER PROCEDURE [dbo].[USP_DWH_GetMonthlyVehicleBreakdownByCounty]
				@Status NVarChar(20)
				, @ExtractDate NVarChar (20)
				, @County NVarChar (50)
As

Set NoCount On;

--Declare @Status NVarChar(20)
--Declare @ExtractDate NVarChar (20)
--Declare @County NVarChar (50)
--Set @Status='Active'
--Set @ExtractDate='2013-July'
--Set @County='ALL'
--Set @ExtractDate = '01 ' + Left(DateName(Month, @ExtractDate), 3) + ' ' + Right(Year(@ExtractDate), 2)
Set @ExtractDate = '01 ' + Left(DateName(Month, CAST(@ExtractDate AS DATETIME)), 3) + ' ' + Right(Year(CAST(@ExtractDate AS DATETIME)), 2) 

Create Table #Vehicles 
	(
		Reg_Nbr NVarChar (50)
		, Plate_Nbr NVarChar (50)
		, Licence_Nbr NVarChar (50)
		, Old_Plate_Nbr NVarChar (50)
		, First_Nm NVarChar (50)
		, Last_Nm NVarChar (50)
		, Title_Cd NVarChar (50)
		, Addr_1 NVarChar (100)
		, Addr_2 NVarChar (100)
		, Town NVarChar (50)
		, Company NVarChar (250)
		, Status NVarChar (50)
		, Authority NVarChar (50)
		, County NVarChar (50)
		, ExpiryDate NVarChar (50)
		, Make NVarChar (50)
		, Model NVarChar (50)
		, Colour NVarChar (50)
		, PhoneNumber NVarChar (50)
		, MobileNumber NVarChar (50)
		, Pps_Number NVarChar (50)
		, Company_Number NVarChar (50)
		, Refused_Mobile_No NVarChar (50)
		, VIN NVarChar (50)
		, DateFirstReg NVarChar (50)
		, EngineCC NVarChar (50)
		, LicenceLetter NVarChar (50)
		, NbrPassengers NVarChar (50)
		, IssueDate NVarChar (50)
		, TestCentre NVarChar (50)
		, TaxClearanceNumber NVarChar (50)
		, TaxClearanceExpiryDate NVarChar (50)
		, InsuranceCertNumber NVarChar (50)
		, InsuranceCertExpiryDate NVarChar (50)
		, VehicleAge SmallInt
		, SPSVCategory NVarChar (50)
	)

Insert Into #Vehicles 
(
	Reg_Nbr, Plate_Nbr, Licence_Nbr, Old_Plate_Nbr, First_Nm, Last_Nm, Title_Cd
	, Addr_1, Addr_2, Town, Company, Status, Authority, County, ExpiryDate
	, Make, Model, Colour, PhoneNumber, MobileNumber, Pps_Number, Company_Number
	, Refused_Mobile_No, VIN, DateFirstReg, EngineCC, LicenceLetter, NbrPassengers 
	, IssueDate, TestCentre, TaxClearanceNumber, TaxClearanceExpiryDate
	, InsuranceCertNumber, InsuranceCertExpiryDate, VehicleAge, SPSVCategory
)
Select Distinct 
	Reg_Nbr, Plate_Nbr, Licence_Nbr, Old_Plate_Nbr, First_Nm, Last_Nm, Title_Cd, Addr_1, Addr_2
	, Town, Company, Status, Authority, dbo.Fn_DWH_GetAlphaNumeric(Replace(Replace(County, '.', ''), 'CO ', '')), ExpiryDate, Make, Model, Colour, PhoneNumber
	, MobileNumber, Pps_Number, Company_Number, Refused_Mobile_No, VIN, DateFirstReg, EngineCC
	, LicenceLetter, NbrPassengers, IssueDate, TestCentre, TaxClearanceNumber
	, TaxClearanceExpiryDate, InsuranceCertNumber, InsuranceCertExpiryDate
	, Case IsNumeric(Left(Reg_Nbr, 2))
		When 1 Then 
			Case 
				When IsNumeric(Left(Reg_Nbr, 3)) = 1 Then 30
				When Cast(Left(Reg_Nbr, 2) As SmallInt) > 20 Then Year(@ExtractDate) - (1900 + Cast(Left(Reg_Nbr, 2) As SmallInt))
				Else (Right(Year(@ExtractDate), 2) - Cast(Left(Reg_Nbr, 2) As SmallInt))
			End
		Else 30
	  End, IsNull(dbo.DWH_SPSVCategory.CategoryDescription, 'Not Categorised')
From 
	dbo.LICENCES_EXTRACT_ARCHIVE_ALL With (NoLock) Left Outer Join dbo.DWH_SPSVCategory With (NoLock) 
			On Left(dbo.LICENCES_EXTRACT_ARCHIVE_ALL.Licence_Nbr, 1) = dbo.DWH_SPSVCategory.CategoryId
Where 
	impFileDate = Cast(Convert(NVarChar(20), DateAdd(Day, -1, DateAdd(Month, 1, Cast(Year(@ExtractDate) As VarChar) + '-' + Cast(Month(@ExtractDate) As VarChar) + '-01')), 111) As DateTime)
	And Status = @Status
	And Plate_Nbr Not In ('54322', '54323', '54321', '54321', '35210', '40241', '38386', '41505')

Set NoCount Off;

If @County = 'ALL'
	BEGIN
	Select County
	, SPSVCategory, Count(*) As NumberOfVehicles From #Vehicles where County<>'0'  Group By County, SPSVCategory Order By County
	END
ELSE
	BEGIN
	Select County
	, SPSVCategory, Count(*) As NumberOfVehicles From #Vehicles Where County like '%' +@County+'%' Group By County, SPSVCategory Order By County
	END

Set NoCount On;
Drop Table #Vehicles
Set NoCount Off;
GO


