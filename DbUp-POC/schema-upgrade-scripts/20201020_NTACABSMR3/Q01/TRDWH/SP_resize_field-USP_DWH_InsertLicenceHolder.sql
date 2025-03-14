USE [TRDWH]
GO

/****** Object:  StoredProcedure [dbo].[USP_DWH_InsertLicenceHolder]    Script Date: 5/14/2020 4:13:53 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*
=============================================
-- Author:		Robert Hamilton
-- Create date: 15-Jul-2009
-- Description:	Returns all possible Status codes present in status table

Exec USP_DWH_InsertLicenceHolder 'H10004', ''

=============================================
*/
ALTER Procedure [dbo].[USP_DWH_InsertLicenceHolder]
					@Title_Cd NVarChar (50)
					, @First_Nm NVarChar (50)
					, @Last_Nm NVarChar (50)
					, @Company_Number NVarChar (50)
					, @Company NVarChar (100)
					, @Addr_1 NVarChar (100)
					, @Addr_2 NVarChar (100)
					, @Town NVarChar (50)
					, @County NVarChar (50)
					, @PhoneNumber NVarChar (50)
					, @MobileNumber NVarChar (50)
					, @Pps_Number NVarChar (50)
					, @TaxClearanceNumber NVarChar (50)
					, @TaxClearanceExpiryDate NVarChar (50)
					, @SPSVCategoryId NVarChar (50)
As

Set NoCount On;
Set Transaction Isolation Level Serializable;

Begin Transaction InsertLicHolder

Update dbo.DWH_Parameter With (RowLock) Set ParameterValue = ParameterValue + 1 Where ParameterName = 'VehicleHolderLicenceNumber'

Insert Into dbo.DWH_LicenceHolderMaster
	(Title_Cd
	, First_Nm
	, Last_Nm
	, Company_Number
	, Company
	, Addr_1
	, Addr_2
	, Town
	, County
	, PhoneNumber
	, MobileNumber
	, Pps_Number
	, TaxClearanceNumber
	, TaxClearanceExpiryDate)

Values 
	(@Title_Cd
	, @First_Nm
	, @Last_Nm
	, @Company_Number
	, @Company
	, @Addr_1
	, @Addr_2
	, @Town
	, @County
	, @PhoneNumber
	, @MobileNumber
	, @Pps_Number
	, @TaxClearanceNumber
	, @TaxClearanceExpiryDate)

If @@Error = 0
	Commit Transaction InsertLicHolder
Else
	RollBack Transaction InsertLicHolder
GO


