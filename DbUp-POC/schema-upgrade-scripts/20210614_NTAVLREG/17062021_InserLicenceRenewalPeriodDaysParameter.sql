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
           ('LicenceRenewalPeriod'
           ,2
           ,'int'
           ,'Licence renewal period in years until licence status will be changed to Dead - Timed Out'
           ,'script'
           ,GETDATE()
           ,'script'
           ,GETDATE())
GO

