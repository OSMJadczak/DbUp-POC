USE [TRDWH]
GO
/****** Object:  StoredProcedure [dbo].[USP_DWH_CreateDriverSnapShot]    Script Date: 09/03/2021 16:24:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[USP_DWH_CreateDriverSnapShot]
AS
INSERT INTO [dbo].[DWH_Driver_SnapShot] (
[fname], 
[sname],
[add1],
[add2],
[add3],
[add4],
[dob],
[licNum],
[issueDate],
[ExpDate],
[PrimLicenseArea],
[SecLicenseArea],
[RSINum],
[GardaArea],
[LicenseStatus],
[FullStatus],
[comment1],
[mobile],
[phone],
[Surrend],
[Deceased],
[Revoked],
[driverManReceived],
[manual6Digit],
[SnapShotDateTime])

Select 
	lhm.FirstName, 
	Lhm.LastName, 
	Lhm.AddressLine1, 
	Lhm.AddressLine2, 
	Lhm.Town, 
	C.CountyName, 
	Lhm.DateOfBirth, 
	Lm.licenceNumber, 
	Lm.LicenceIssueDate, 
	Lm.LicenceExpiryDate, 
	pa.AreaName,
	stuff((select ';' + a.AreaName
	 from dbo.AdditionalArea aa
	 inner join dbo.Area a on aa.AdditionalAreaId=a.AreaId
	 where aa.LicenceMasterId=lhm.LicenceHolderId
	 for xml path ('')
	 ), 1, 1, '') 'AdditionalAreas',
	Lhm.Ppsn, 
	Gd.GardaDivisionName, 
	Case When Lm.LicenceStateMasterId = 1 Then 1 Else 0 End 'LicenseStatus', 
	lsm.LicenceStateMaster as [FullStatus],
	lhm.Comments, 
	Lhm.PhoneNo1, 
	Lhm.PhoneNo2, 
	Case When Lm.LicenceStateMasterId = 2 and lm.LicenceStateID = 5 Then 'YES' Else 'NO' End 'Surrend',
	Case When Lhm.DeceasedYn = 0 Then 'NO' Else 'YES' End 'Deceased', 
	Case When Lm.LicenceStateMasterId = 2 and lm.LicenceStateID = 6 Then 'YES' Else 'NO' End 'Revoked', 			
	Case When IsNull(_6DigitCode, '') = '' Then 'NO' Else 'YES' End 'driverManReceived', 
	_6DigitCode, 
	dateAdd(Day, -1, Convert(VarChar(20), GetDate(), 111)) 'SnapShotDateTime'
From 
	dbo.LicenceHolderMaster As Lhm 
	inner Join dbo.LicenceMaster As Lm On Lhm.LicenceHolderId = Lm.LicenceHolderId 
	left Join dbo.GardaDivision As Gd On Lhm.GardaDivisionID = Gd.GardaDivisionID 
	left Join dbo.Person_County As C On Lhm.CountyID = C.CountyID
	left join dbo.Area pa on pa.AreaId=lhm.PrimaryAreaId
	left join dbo.LicenceStateMaster lsm on lsm.LicenceStateMasterID = lm.LicenceStateMasterID
