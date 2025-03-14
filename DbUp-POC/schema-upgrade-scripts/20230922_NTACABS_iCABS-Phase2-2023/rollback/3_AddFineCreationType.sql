USE [cabs_production]
GO

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
      FROM [cabs_enf].[Fines]
GO
