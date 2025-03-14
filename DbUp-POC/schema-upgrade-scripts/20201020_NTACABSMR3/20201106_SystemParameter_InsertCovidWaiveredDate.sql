USE [cabs_production]
GO

INSERT INTO [dbo].[SystemParameter]
           ([ParameterName]
           ,[ParameterValue]
           ,[ParameterType]
           ,[ParameterDescription]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[ModifiedBy]
           ,[ModifiedDate])
     VALUES
           ('CovidWaiveredDateFrom'
           ,'01-Jan-2021'
           ,'datetime'
           ,'The date after covid waiver message should appear.'
           ,'script'
           ,GETDATE()
           ,'script'
           ,GETDATE())
GO

INSERT INTO [dbo].[SystemParameter]
           ([ParameterName]
           ,[ParameterValue]
           ,[ParameterType]
           ,[ParameterDescription]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[ModifiedBy]
           ,[ModifiedDate])
     VALUES
           ('CovidWaiveredDateTo'
           ,'31-Dec-2021'
           ,'datetime'
           ,'The date after covid waiver message should stop appearing.'
           ,'script'
           ,GETDATE()
           ,'script'
           ,GETDATE())
GO


