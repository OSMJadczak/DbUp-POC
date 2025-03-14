USE [cabs_production]
GO

/****** Object:  View [cabs_enf].[vFine]    Script Date: 20/09/2023 12:45:00 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER VIEW [cabs_enf].[vFine]
AS
      select [Id]
      , [Amount]
      , [DatePaid]
      , [DocketNumber]
      , [DriverLicenceNumber]
      , [DueForPayment]
      , [FineAreaId]
      , [FineStatusId]
      , [FineTypeId]
      , [IncidentDate]
      , [InfoLicenceNumber]
      , [IsPaid]
      , [IssueDate]
      , [IssueOfficerName]
      , [RegistrationNumber]
      , [VehicleLicenceNumber]
      , [IssueOfficerId]
      , [InfoRegistrationNumber]
	, [CreatedBy]
	, [CreatedDate]
	, [DriverLicenceId]
	, [FineCreationType]
      FROM [cabs_enf].[Fines]
GO
