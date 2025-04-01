USE [cabs_production]
GO

UPDATE [dbo].[SystemParameter]
 SET [ParameterValue] = '01-Jul-2022'
 WHERE ParameterName = 'CovidWaiveredOnlyActiveFrom'
GO

UPDATE [dbo].[SystemParameter]
 SET [ParameterValue] = '31-Dec-2022'
 WHERE ParameterName = 'CovidWaiveredDateTo'
GO


