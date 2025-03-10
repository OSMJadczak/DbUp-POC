SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [cabs_enf].[vComplaints]
AS
SELECT [cpls].[CaseId]
	,[cpls].[Category]
	,[cpls].[DriverLicenceNumber]
	,[cpls].[CreatedOn]
	,[cpls].[ProgressStatusId]
	,ISNULL([cpls].[Resolution], 'NONE') AS Resolution
	,[cpls].[Title]
	,[cpls].[Text]
	,[ud].[FullName] AS [ResolvedBy]
FROM (
	SELECT [c].[id] AS [CaseId]
		,CASE WHEN [c].[field1] = '' then c.linkedDriver else c.field1 end AS [DriverLicenceNumber]
		,[c].creation_date AS [CreatedOn]
		,[c].progressStatus_id AS [ProgressStatusId]
		,[c].[body] AS [Text]
		,[c].[title] AS [Title]
		,[cr].ShortName AS [Resolution]
		,[cc].[name] AS [Category]
		,(
			SELECT [t2].[createdBy]
			FROM (
				SELECT TOP (1) [t1].[createdBy]
				FROM [Cabs_Live].[dbo].[Case_History] AS [t1]
				WHERE ([t1].[field_name] LIKE 'Resolved By%')
					AND ([t1].[caseid] = [c].[id])
				ORDER BY [t1].[id] DESC
				) AS [t2]
			) AS [EOId]
	FROM [Cabs_Live].[dbo].[Cases] AS [c]
	LEFT JOIN [Cabs_Live].[dbo].[Case_Category_Internal] AS cc ON cc.id = c.category_id
	LEFT JOIN Cabs_Live.dbo.Case_Resolution AS cr ON cr.Id = c.case_resolutionFK
	) AS cpls
LEFT JOIN [cabs_production].[cabs_cmo].[UserDetails] AS ud ON ud.UserId = cpls.EOId
GO
