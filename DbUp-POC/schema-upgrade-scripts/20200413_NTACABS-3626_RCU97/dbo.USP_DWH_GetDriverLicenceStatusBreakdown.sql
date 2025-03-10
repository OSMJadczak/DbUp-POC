USE [TRDWH]
GO
/****** Object:  StoredProcedure [dbo].[USP_DWH_GetVehicleAgeBreakdownBiYearlyNEW]    Script Date: 03/03/2021 09:25:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*
=============================================
-- Author:		Adam Nosal
-- Create date: 28-Feb-2021
-- Description:	

Exec USP_DWH_GetDriverLicenceStatusBreakdown  '31-12-2008'

=============================================
*/
create or ALTER PROCEDURE [dbo].[USP_DWH_GetDriverLicenceStatusBreakdown]
				--@Status NVarChar(20), 
				@ExtractDate date
As

BEGIN 

Set NoCount On;

Create Table #Licences 
	(
		 Licence_Nbr NVarChar (50)
		, FullStatus NVarChar (50)
	)


Insert Into #Licences 
(
	 Licence_Nbr, FullStatus
)

Select e.licNum,
	 FullStatus
From 
	dbo.[DWH_Driver_SnapShot] E With (NoLock) 
Where 
	cast( e.SnapShotDateTime as date)  = @ExtractDate
	

Set NoCount Off;

Select 0 As RankOrder, 'Active' As Status, Count(*) As NumberOfLicences From #Licences Where FullStatus = 'Active' 
Union All
Select 1 As RankOrder, 'Inactive Expired' As Status,  Count(*) As NumberOfLicences From #Licences Where FullStatus = 'Inactive - Expired' 
--Union All
--Select 2 As RankOrder, 'Inactive Deferred' As Status,   Count(*) As NumberOfLicences From #Licences Where FullStatus = 'Inactive - Deferred' 
--Union All
--Select 3 As RankOrder, 'Inactive Conditional Offer' As Status,   Count(*) As NumberOfLicences From #Licences Where FullStatus ='Inactive - Conditional Offer'   
Union All
Select 3 As RankOrder, 'Inactive Suspended' As Status,   Count(*) As NumberOfLicences From #Licences Where FullStatus = 'Inactive - Suspended'  
Union All
Select 4 As RankOrder, 'Dead Timed Out' As Status,   Count(*) As NumberOfLicences From #Licences Where FullStatus = 'Dead - Timed Out'  
Union All
Select 5 As RankOrder, 'Dead Surrendered' As Status,   Count(*) As NumberOfLicences From #Licences Where FullStatus =  'Dead - Surrendered'  
Union All
Select 6 As RankOrder, 'Dead Revoked' As Status,   Count(*) As NumberOfLicences From #Licences Where FullStatus =  'Dead - Revoked'   
--Union All
--Select 8 As RankOrder, 'Dead Conditional Offer ' As Status,   Count(*) As NumberOfLicences From #Licences Where FullStatus = 'Dead - Conditional Offer'  

--change this to Status table import 

Set NoCount On;
Drop Table #Licences
Set NoCount Off;

END 