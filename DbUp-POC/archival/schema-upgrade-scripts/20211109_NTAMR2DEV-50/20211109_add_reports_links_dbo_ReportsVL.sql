USE [cabs_production]
GO

INSERT INTO [dbo].[ReportsVL]
           ([ReportName]
           ,[ReportPath]
           ,[AllowedRoles]
           ,[ReportSection]
           ,[Order])
     VALUES
		(
			'Compliance Report'
			,'/Compliance/Compliance Report'
			,'*'
			,4
			,4
		),
		(
			'MVLO Report'
			,'/Compliance/MVLO Report'
			,'*'
			,4
			,5
		)
GO
