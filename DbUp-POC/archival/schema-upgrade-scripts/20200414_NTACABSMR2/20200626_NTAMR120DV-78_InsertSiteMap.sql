USE [cabs_production]
GO

INSERT INTO [dbo].[aspnet_SiteMap]
           ([ID]
           ,[Title]
           ,[Description]
           ,[Url]
           ,[Roles]
           ,[ReliantOn]
           ,[Parent])
     VALUES
           (241
           ,'Section15Renewal'
           ,null
           ,'~/Sections/VehicleLicencing/Processes/Section15TransferRenew/SectionRenewal8.aspx'
           ,'global_admin,vl_agent,vl_admin,vl_supervisor1'
           ,NULL
           ,20)
GO
