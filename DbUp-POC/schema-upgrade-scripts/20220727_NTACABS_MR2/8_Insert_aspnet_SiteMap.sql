USE [cabs_production]
GO



INSERT INTO [dbo].[aspnet_SiteMap]
           (
            [Id]
           ,[Title]
           ,[Description]
           ,[Url]
           ,[Roles]
           ,[ReliantOn]
           ,[Parent])
     VALUES
           (
            242
           ,'Returned Licence Documents'
           ,NULL
           ,'~/Sections/VehicleLicencing/Dashboard/ReturnedLicenceDocuments/ReturnedLicenceDocuments.aspx'
           ,'global_admin'
           ,NULL
           ,20),
           (
            243
           ,'Returned Licence Documents Audit List'
           ,NULL
           ,'~/Sections/VehicleLicencing/Dashboard/History/ReturnedLicenceDocumentsAuditList.aspx'
           ,'*'
           ,NULL
           ,20)
GO