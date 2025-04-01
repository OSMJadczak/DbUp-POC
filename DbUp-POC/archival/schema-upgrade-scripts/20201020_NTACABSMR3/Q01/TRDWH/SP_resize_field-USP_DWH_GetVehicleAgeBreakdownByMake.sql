USE [TRDWH]
GO

/****** Object:  StoredProcedure [dbo].[USP_DWH_GetVehicleAgeBreakdownByMake]    Script Date: 5/14/2020 4:07:36 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*
=============================================
-- Author:		Robert Hamilton
-- Create date: 15-Jul-2009
-- Description:	Returns all possible Status codes present in status table

Exec USP_DWH_GetVehicleAgeBreakdownByMake 'ACTIVE', '31/Dec/2008'

=============================================
*/
ALTER PROCEDURE [dbo].[USP_DWH_GetVehicleAgeBreakdownByMake]
				@Status NVarChar(20)
				, @ExtractDate DateTime
				--, @VehicleAge SmallInt
As

Set NoCount On;

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
/*
Select 
	VM.Reg_Nbr, LM.Plate_Nbr, LM.Licence_Nbr, '' As Old_Plate_Nbr, LHM.First_Nm, LHM.Last_Nm, LHM.Title_Cd, LHM.Addr_1, LHM.Addr_2
	, LHM.Town, LHM.Company, LM.LicenceState, '' As Authority, LHM.County, LM.ExpiryDate, VM.Make, VM.Model, VM.Colour, LHM.PhoneNumber
	, LHM.MobileNumber, LHM.Pps_Number, LHM.Company_Number, '' As Refused_Mobile_No, VM.VIN, VM.DateFirstReg, VM.EngineCC
	, LM.SPSVCategoryId As LicenceLetter, VM.NbrPassengers, LM.IssueDate, '' As TestCentre, LHM.TaxClearanceNumber
	, LHM.TaxClearanceExpiryDate, '' As InsuranceCertNumber, '' As InsuranceCertExpiryDate
	, Case IsNumeric(Left(VM.Reg_Nbr, 2))
		When 1 Then 
			Case 
				When IsNumeric(Left(VM.Reg_Nbr, 3)) = 1 Then 30
				When Cast(Left(VM.Reg_Nbr, 2) As SmallInt) > 20 Then Year(@ExtractDate) - (1900 + Cast(Left(VM.Reg_Nbr, 2) As SmallInt))
				Else (Right(Year(@ExtractDate), 2) - Cast(Left(VM.Reg_Nbr, 2) As SmallInt))
			End
		Else 30
	  End
	, IsNull(dbo.DWH_SPSVCategory.CategoryDescription, 'Not Categorised')
From 
	dbo.DWH_LicenceHolderMaster As LHM With (NoLock) Inner Join dbo.DWH_LicenceMaster As LM With (NoLock) On LHM.CCSN = LM.CCSN Inner Join dbo.DWH_VehicleMaster As VM With (NoLock) On LM.Reg_Nbr = VM.Reg_Nbr Left Outer Join dbo.DWH_SPSVCategory With (NoLock) 
	On LM.SPSVCategoryId = dbo.DWH_SPSVCategory.CategoryId
Where 
	LM.LicenceState = @Status
	And LM.Plate_Nbr Not In ('54322', '54323', '54321', '54321', '35210', '40241', '38386', '41505')
*/
Select 
	Reg_Nbr, Plate_Nbr, Licence_Nbr, Old_Plate_Nbr, First_Nm, Last_Nm, Title_Cd, Addr_1, Addr_2
	, Town, Company, Status, Authority, County, ExpiryDate, Make, Model, Colour, PhoneNumber
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
	impFileDate = @ExtractDate--(Select Max(impFileDate) From dbo.LICENCES_EXTRACT_ARCHIVE_ALL)
	And Status = @Status
	And Plate_Nbr Not In ('54322', '54323', '54321', '54321', '35210', '40241', '38386', '41505')

Set NoCount Off;

Select Make, SPSVCategory, Count(*) As NumberOfVehicles From #Vehicles Group By Make, SPSVCategory

Set NoCount On;
Drop Table #Vehicles
Set NoCount Off;
GO


