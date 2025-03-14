USE [TRDWH]
GO

/****** Object:  StoredProcedure [dbo].[USP_DWH_GetVehicleByAge]    Script Date: 5/14/2020 4:10:09 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*
=============================================
-- Author:		Robert Hamilton
-- Create date: 15-Jul-2009
-- Description:	Returns all possible Status codes present in status table

Exec USP_DWH_GetVehicleByAge 0, 'ACTIVE'

=============================================
*/
ALTER Procedure [dbo].[USP_DWH_GetVehicleByAge] 
				@VehicleAge SmallInt
				, @Status NVarChar (50)
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
	)

	Insert Into #Vehicles 
	(
		Reg_Nbr, Plate_Nbr, Licence_Nbr, Old_Plate_Nbr, First_Nm, Last_Nm, Title_Cd
		, Addr_1, Addr_2, Town, Company, Status, Authority, County, ExpiryDate
		, Make, Model, Colour, PhoneNumber, MobileNumber, Pps_Number, Company_Number
		, Refused_Mobile_No, VIN, DateFirstReg, EngineCC, LicenceLetter, NbrPassengers 
		, IssueDate, TestCentre, TaxClearanceNumber, TaxClearanceExpiryDate
		, InsuranceCertNumber, InsuranceCertExpiryDate, VehicleAge
	)
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
					When Cast(Left(Reg_Nbr, 2) As SmallInt) > 20 Then Year(GetDate()) - (1900 + Cast(Left(Reg_Nbr, 2) As SmallInt))
					Else (Right(Year(GetDate()), 2) - Cast(Left(Reg_Nbr, 2) As SmallInt))
				End
			Else 30
		  End
	From 
		dbo.LICENCES_EXTRACT_ARCHIVE_ALL With (NoLock)
	Where 
		impFileDate = (Select Max(impFileDate) From dbo.LICENCES_EXTRACT_ARCHIVE_ALL)
		And Status = @Status
		And Plate_Nbr Not In ('54322', '54323', '54321', '54321', '35210', '40241', '38386', '41505')

Set NoCount Off;

Select * From #Vehicles Where VehicleAge = @VehicleAge Order By Reg_Nbr

Set NoCount On;
Drop Table #Vehicles
Set NoCount Off;
GO


