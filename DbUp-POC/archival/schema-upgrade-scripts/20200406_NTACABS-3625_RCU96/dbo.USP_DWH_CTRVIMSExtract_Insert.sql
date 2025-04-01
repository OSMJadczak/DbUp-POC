USE [TRDWH]
GO
/****** Object:  StoredProcedure [dbo].[USP_DWH_CTRVIMSExtract_Insert]    Script Date: 09/03/2021 16:31:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
=============================================
-- Author:		Robert Hamilton
-- Create date: 15-Jul-2009
-- Description:	Returns all possible Status codes present in status table

Exec USP_DWH_CTRVIMSExtract_Insert

=============================================
*/
ALTER Procedure [dbo].[USP_DWH_CTRVIMSExtract_Insert]
As

Set NoCount On;

DELETE [dbo].[LICENCES_EXTRACT]

INSERT INTO [dbo].[LICENCES_EXTRACT]
           ([Reg_Nbr]
           ,[Plate_Nbr]
           ,[Licence_Nbr]
           ,[Old_Plate_Nbr]
           ,[First_Nm]
           ,[Last_Nm]
           ,[Title_Cd]
           ,[Addr_1]
           ,[Addr_2]
           ,[Town]
           ,[Company]
           ,[Status]
		   ,[FullStatus]
           ,[Authority]
           ,[County]
           ,[ExpiryDate]
           ,[Make]
           ,[Model]
           ,[Colour]
           ,[PhoneNumber]
           ,[MobileNumber]
           ,[Pps_Number]
           ,[Company_Number]
           ,[Refused_Mobile_No ]
           ,[VIN]
           ,[DateFirstReg]
           ,[EngineCC]
           ,[LicenceLetter]
           ,[NbrPassengers]
           ,[IssueDate]
           ,[TestCentre]
           ,[TaxClearanceNumber]
           ,[TaxClearanceExpiryDate]
           ,[InsuranceCertNumber]
           ,[InsuranceCertExpiryDate]
           --,[SnapShotDateTime]
           )
	Select 
		VM.Reg_Nbr, LM.Plate_Nbr, LM.Licence_Nbr, '' As Old_Plate_Nbr, LHM.First_Nm, LHM.Last_Nm, LHM.Title_Cd, LHM.Addr_1, LHM.Addr_2
		, LHM.Town, LHM.Company, LM.LicenceState As [Status], 
		case when lm.LicenceState = 'Active' then lm.LicenceState else lm.LicenceState + ' ' +lm.LicenceSubState end as  [FullStatus]
		,  '' As Authority, LHM.County, LM.ExpiryDate, VM.Make, VM.Model, VM.Colour, LHM.PhoneNumber
		, LHM.MobileNumber, LHM.Pps_Number, LHM.Company_Number, '' As Refused_Mobile_No, VM.VIN, VM.DateFirstReg, VM.EngineCC
		, LM.SPSVCategoryId As LicenceLetter, VM.NbrPassengers, LM.IssueDate, '' As TestCentre, LHM.TaxClearanceNumber
		, LHM.TaxClearanceExpiryDate, '' As InsuranceCertNumber, '' As InsuranceCertExpiryDate--, '2010-02-28 00:00:00'--Convert(VarChar(10), GetDate(), 111)
	From 
		dbo.DWH_LicenceHolderMaster As LHM With (NoLock) Inner Join dbo.DWH_LicenceMaster As LM With (NoLock) On LHM.CCSN = LM.CCSN Inner Join dbo.DWH_VehicleMaster As VM With (NoLock) On LM.Reg_Nbr = VM.Reg_Nbr 
	Where 
	--lm.licencestate = 'ACTIVE'
	--	And 
		LM.Plate_Nbr Not In ('54322', '54323', '54321', '35210', '40241', '38386', '41505')

UPDATE dbo.LICENCES_EXTRACT 
SET InsuranceCertExpiryDate = Replace(InsuranceCertExpiryDate, Char(13), ''), County = (
CASE
WHEN County LIKE '%DUBLIN%'
THEN 'CO. DUBLIN'
WHEN County LIKE '%MEATH%' AND County NOT LIKE '%WESTMEATH%'
THEN 'CO. MEATH'
WHEN County LIKE '%LOUTH%'
THEN 'CO. LOUTH'
WHEN County LIKE '%MONAGHAN%'
THEN 'CO. MONAGHAN'
WHEN County LIKE '%WICKLOW%'
THEN 'CO. WICKLOW'
WHEN County LIKE '%WEXFORD%'
THEN 'CO. WEXFORD'
WHEN County LIKE '%KILKENNY%'
THEN 'CO. KILKENNY'
WHEN County LIKE '%TIPPERARY%'
THEN 'CO. TIPPERARY'
WHEN County LIKE '%OFFALY%'
THEN 'CO. OFFALY'
WHEN County LIKE '%CORK%'
THEN 'CO. CORK'
WHEN County LIKE '%KERRY%'
THEN 'CO. KERRY'
WHEN County LIKE '%CLARE%'
THEN 'CO. CLARE'
WHEN County LIKE '%LIMERICK%'
THEN 'CO. LIMERICK'
WHEN County LIKE '%WESTMEATH%'
THEN 'CO. WESTMEATH'
WHEN County LIKE '%SLIGO%'
THEN 'CO. SLIGO'
WHEN County LIKE '%GALWAY%'
THEN 'CO. GALWAY'
WHEN County LIKE '%ROSCOMMON%'
THEN 'CO. ROSCOMMON'
WHEN County LIKE '%MAYO%'
THEN 'CO. MAYO'
WHEN County LIKE '%DONEGAL%'
THEN 'CO. DONEGAL'
WHEN County LIKE '%CAVAN%'
THEN 'CO. CAVAN'
WHEN County LIKE '%WATERFORD%'
THEN 'CO. WATERFORD'
WHEN County LIKE '%LEITRIM%'
THEN 'CO. LEITRIM'
WHEN County LIKE '%LONGFORD%'
THEN 'CO. LONGFORD'
WHEN County LIKE '%LAOIS%'
THEN 'CO. LAOIS'
WHEN County LIKE '%KILDARE%'
THEN 'CO. KILDARE'
WHEN County LIKE '%CARLOW%'
THEN 'CO. CARLOW'
ELSE County
END
)


INSERT INTO dbo.LICENCES_EXTRACT_ARCHIVE 
([Reg_Nbr]
           ,[Plate_Nbr]
           ,[Licence_Nbr]
           ,[Old_Plate_Nbr]
           ,[First_Nm]
           ,[Last_Nm]
           ,[Title_Cd]
           ,[Addr_1]
           ,[Addr_2]
           ,[Town]
           ,[Company]
           ,[Status]
           ,[FullStatus]
           ,[Authority]
           ,[County]
           ,[ExpiryDate]
           ,[Make]
           ,[Model]
           ,[Colour]
           ,[PhoneNumber]
           ,[MobileNumber]
           ,[Pps_Number]
           ,[Company_Number]
           ,[Refused_Mobile_No ]
           ,[VIN]
           ,[DateFirstReg]
           ,[EngineCC]
           ,[LicenceLetter]
           ,[NbrPassengers]
           ,[IssueDate]
           ,[TestCentre]
           ,[TaxClearanceNumber]
           ,[TaxClearanceExpiryDate]
           ,[InsuranceCertNumber]
           ,[InsuranceCertExpiryDate]
           ,[impDateStamp]
           ,[impFileName]
           ,[impFileDate]
           ,[impFileYear]
           ,[impFileMonth]
           ,[impFileDay]
           ,[impFileQuarter])
SELECT [Reg_Nbr]
           ,[Plate_Nbr]
           ,[Licence_Nbr]
           ,[Old_Plate_Nbr]
           ,[First_Nm]
           ,[Last_Nm]
           ,[Title_Cd]
           ,[Addr_1]
           ,[Addr_2]
           ,[Town]
           ,[Company]
           ,[Status]
		   ,[FullStatus]
           ,[Authority]
           ,[County]
           ,[ExpiryDate]
           ,[Make]
           ,[Model]
           ,[Colour]
           ,[PhoneNumber]
           ,[MobileNumber]
           ,[Pps_Number]
           ,[Company_Number]
           ,[Refused_Mobile_No ]
           ,[VIN]
           ,[DateFirstReg]
           ,[EngineCC]
           ,[LicenceLetter]
           ,[NbrPassengers]
           ,[IssueDate]
           ,[TestCentre]
           ,[TaxClearanceNumber]
           ,[TaxClearanceExpiryDate]
           ,[InsuranceCertNumber]
           ,[InsuranceCertExpiryDate]
, GetDate()
, 'CTRVIMS'
, Convert(VarChar(20), GetDate(), 111)
, Year(GetDate()), Month(GetDate())
, Day(GetDate()), DatePart(Quarter, GetDate())
FROM dbo.LICENCES_EXTRACT

IF (SELECT TOP 1 impFileDay FROM dbo.LICENCES_EXTRACT_ARCHIVE) = '01'
BEGIN
INSERT dbo.LICENCES_EXTRACT_EOM
SELECT * FROM dbo.LICENCES_EXTRACT_ARCHIVE
WHERE impFileDay = '01'
ORDER BY impFileDate
END

INSERT dbo.LICENCES_EXTRACT_ARCHIVE_ALL
SELECT * FROM dbo.LICENCES_EXTRACT_ARCHIVE

DELETE DWH_LICENSES_HISTORY
INSERT DWH_LICENSES_HISTORY
([Reg_Nbr]
           ,[Plate_Nbr]
           ,[Licence_Nbr]
           ,[Old_Plate_Nbr]
           ,[First_Nm]
           ,[Last_Nm]
           ,[Title_Cd]
           ,[Addr_1]
           ,[Addr_2]
           ,[Town]
           ,[Company]
           ,[Status]
		   ,[FullStatus]
           ,[Authority]
           ,[County]
           ,[ExpiryDate]
           ,[Make]
           ,[Model]
           ,[Colour]
           ,[PhoneNumber]
           ,[MobileNumber]
           ,[Pps_Number]
           ,[Company_Number]
           ,[Refused_Mobile_No ]
           ,[VIN]
           ,[DateFirstReg]
           ,[EngineCC]
           ,[LicenceLetter]
           ,[NbrPassengers]
           ,[IssueDate]
           ,[TestCentre]
           ,[TaxClearanceNumber]
           ,[TaxClearanceExpiryDate]
           ,[InsuranceCertNumber]
           ,[InsuranceCertExpiryDate]
           ,[impFileDate]
           )
SELECT 
Reg_Nbr,
Plate_Nbr,
Licence_Nbr,
Old_Plate_Nbr,
First_Nm,
Last_Nm,
Title_Cd,
Addr_1,
Addr_2,
Town,
Company,
Status,
FullStatus,
Authority,
County,
ExpiryDate,
Make,
Model,
Colour,
PhoneNumber,
MobileNumber,
Pps_Number,
Company_Number,
null,
VIN, DateFirstReg, EngineCC, LicenceLetter, NbrPassengers, IssueDate, TestCentre, TaxClearanceNumber, TaxClearanceExpiryDate,
InsuranceCertNumber, 
InsuranceCertExpiryDate, 
MAX(impFileDate)
FROM dbo.LICENCES_EXTRACT_ARCHIVE_ALL 
WHERE Plate_Nbr <> ''
GROUP BY
Reg_Nbr,
Plate_Nbr,
Licence_Nbr,
Old_Plate_Nbr,
First_Nm,
Last_Nm,
Title_Cd,
Addr_1,
Addr_2,
Town,
Company,
Status,
FullStatus,
Authority,
County,
ExpiryDate,
Make,
Model,
Colour,
PhoneNumber,
MobileNumber,
Pps_Number,
Company_Number,
VIN, DateFirstReg, EngineCC, LicenceLetter, NbrPassengers, IssueDate, TestCentre, TaxClearanceNumber, TaxClearanceExpiryDate,
InsuranceCertNumber, InsuranceCertExpiryDate
ORDER BY Licence_Nbr, MAX(impFileDate)

DROP TABLE DWH_VEHICLE_DAILY

CREATE TABLE DWH_VEHICLE_DAILY
(
impFileDate	smalldatetime,
impFileDay	nvarchar(5),
impFileMonth	nvarchar(5),
impFileYear	nvarchar(5),
Total	int
)

DROP TABLE DWH_VEHICLE_MONTHLY

CREATE TABLE DWH_VEHICLE_MONTHLY
(
impFileDate	smalldatetime,
ReportMonth	nvarchar(6),
impFileDay	nvarchar(5),
impFileMonth	nvarchar(5),
impFileYear	nvarchar(5),
impFileQuarter	int,
Total	int
)

DROP TABLE DWH_VEHICLE_COUNTY

CREATE TABLE DWH_VEHICLE_COUNTY
(
County	nvarchar(50),
Total	int,
impFileDate	smalldatetime,
impFileDay	nvarchar(5),
impFileMonth	nvarchar(5),
impFileYear	nvarchar(5)
)

DROP TABLE DWH_VEHICLE_COUNTY_MONTH

CREATE TABLE DWH_VEHICLE_COUNTY_MONTH
(
County	nvarchar(50),
Total	int,
impFileDate	smalldatetime,
impFileDay	nvarchar(5),
impFileMonth	nvarchar(5),
impFileYear	nvarchar(5)
)

EXEC SP_DWH_VEHICLE_DRIVER_REPORT

DELETE dbo.LICENCES_EXTRACT_ARCHIVE

Set NoCount Off;

