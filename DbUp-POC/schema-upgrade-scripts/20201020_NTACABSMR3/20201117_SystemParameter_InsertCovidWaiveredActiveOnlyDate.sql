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
           ('CovidWaiveredOnlyActiveFrom'
           ,'12-Jun-2021'
           ,'datetime'
           ,'The date after covid waiver message should appear only for active licences.'
           ,'script'
           ,GETDATE()
           ,'script'
           ,GETDATE())
GO

