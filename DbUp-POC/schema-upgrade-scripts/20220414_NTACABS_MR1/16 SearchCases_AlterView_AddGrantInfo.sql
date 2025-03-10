USE [cabs_production]
GO

/****** Object:  View [cabs_cms].[SearchCases]    Script Date: 20.07.2022 13:46:58 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER VIEW [cabs_cms].[SearchCases]
AS 
SELECT DISTINCT
				c.[id]
				, individual.FirstName
				, individual.LastName
	            , c.[parent_category_name]
	            , [casetype]
	            , [title]
	            , [body]
	            , [category_id]          
	            , [visibility_id]
	            , [creation_date]
	            , c.[createdBy]
	            , [severity_id]
	            , field1, field2, field3
	            , c.team_id
	            , progressStatus_id
	            , progressSubstatus_id
	            , assignedTo 
	            , nextreviewdate
                , raisedby_firstname
	            , raisedby_surname
	            , cc.[Name] AS [area]
	            , parentId
	            , linkedDriver
	            , linkedVehicle
	            , linkedSkillsCandidate
	            , case_resolutionFK
				, cps.name as [ProgressStatusName]
				, cs.name as [SeverityName]
				, ct.name as [CaseTeamName]
				, Cabs_Live.[dbo].[fnGetParent] (cci.id) as [InternalCategoryName]
				, vllhm.First_Nm
				, vllhm.Last_Nm
				, vllhm.Company
				, c.raisedby_emailaddress
				, gd.[Id] as GrantId
				, gst.[type] as GrantStatus
				, gst.[Id] as GrantStatusId
            FROM Cabs_Live.dbo.Cases c
                LEFT JOIN [dl].[LicenceMaster] lm ON c.field1 = lm.LicenceNumber
                LEFT JOIN [dl].[LicenceHolderMaster] lhm on lhm.LicenceMasterId = lm.LicenceMasterId
                LEFT JOIN [person].[Person] p on lhm.PersonId = p.PersonId
                LEFT JOIN [person].[Individual] individual on individual.PersonId = p.PersonId
                LEFT JOIN Cabs_Live.dbo.DWH_LicenceHolderMaster vllhm ON vllhm.LicenceHolderURN = c.field3
                LEFT JOIN Cabs_Live.dbo.Case_County AS cc ON cc.id = c.case_countyFK
				LEFT JOIN Cabs_Live.dbo.Case_ProgressStatus as cps on cps.id = c.progressStatus_id
				LEFT JOIN Cabs_Live.dbo.Case_Severity as cs on cs.id = c.severity_id
				LEFT JOIN Cabs_Live.dbo.Case_Team as ct on ct.id = c.team_id
				LEFT JOIN Cabs_Live.dbo.Case_Category_Internal AS cci on cci.id = c.category_id
				LEFT OUTER JOIN Cabs_Live.dbo.GrantDetails AS gd ON gd.CaseReferenceNumber = c.id
				LEFT OUTER JOIN Cabs_Live.dbo.GrantStatusType AS gst ON gd.StatusId = gst.Id
            WHERE parent_category_name IS NOT NULL
GO


