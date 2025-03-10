/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [ReportId]
      ,[ReportName]
      ,[ReportPath]
      ,[AllowedRoles]
      ,[ReportSection]
      ,[Order]
  FROM [cabs_production].[dbo].[ReportsVL]


  begin tran 

  ---------------VL---------------------
INSERT INTO [dbo].[ReportsVL]
           ([ReportName]
           ,[ReportPath]
           ,[AllowedRoles]
           ,[ReportSection]
           ,[Order])
     VALUES
           ('Licence Expiry'
           ,'/Vehicle Licensing/ExpiringLicences'
           ,'*'
           ,1
           ,20)

INSERT INTO [dbo].[ReportsVL]
           ([ReportName]
           ,[ReportPath]
           ,[AllowedRoles]
           ,[ReportSection]
           ,[Order])
     VALUES
           ('Section 15 Completed Nominations'
           ,'/Vehicle Licensing/Section15CompletedNominations'
           ,'*'
           ,1
           ,21)

INSERT INTO [dbo].[ReportsVL]
           ([ReportName]
           ,[ReportPath]
           ,[AllowedRoles]
           ,[ReportSection]
           ,[Order])
     VALUES
           ('Expired vehicle licences'
            ,'/Vehicle Licensing/Expired Vehicle Licences'
           ,'*'
           ,1
           ,22)

INSERT INTO [dbo].[ReportsVL]
           ([ReportName]
           ,[ReportPath]
           ,[AllowedRoles]
           ,[ReportSection]
           ,[Order])
     VALUES
           ('TR_VEH_Transport Statistics'
           ,'/Vehicle Licensing/TR_VEH_TransportStatistics'
           ,'*'
           ,1
           ,23)
		   
INSERT INTO [dbo].[ReportsVL]
           ([ReportName]
           ,[ReportPath]
           ,[AllowedRoles]
           ,[ReportSection]
           ,[Order])
     VALUES
           ('Vehicle Licence Extract'
           ,'/Vehicle Licensing/Vehicle Licence Extract'
           ,'*'
           ,1
           ,24)

    --  INSERT INTO [dbo].[ReportsVL]
    --        ([ReportName] ,[ReportPath],[AllowedRoles] ,[ReportSection],[Order])
    --  VALUES
    --        ('NewLicences'
    --        ,'/Vehicle Licensing/NewLicences'
    --        ,'*'
    --        ,1,25)

-------------DL -----------------------

		-- do not include    		   
--INSERT INTO [dbo].[ReportsVL]
--           ([ReportName]
--           ,[ReportPath]
--           ,[AllowedRoles]
--           ,[ReportSection]
--           ,[Order])
--     VALUES
--           ('Monthly Transaction Summary'
--           ,'/Driver Licensing/MoneyCollected - DLS'
--           ,'*'
--           ,2
--           ,10)

		   		   
-- INSERT INTO [dbo].[ReportsVL]
--            ([ReportName]
--            ,[ReportPath]
--            ,[AllowedRoles]
--            ,[ReportSection]
--            ,[Order])
--      VALUES
--            ('Active Licences by county (Primary Area)'
--            ,'/Monthly Reports/TR_MON_007 - Active Licenses by County (Primary Area only)'
--            ,'*'
--            ,2
--            ,10)

		   -- do not include 
--INSERT INTO [dbo].[ReportsVL]
--           ([ReportName]
--           ,[ReportPath]
--           ,[AllowedRoles]
--           ,[ReportSection]
--           ,[Order])
--     VALUES
--           ('TR_Mon_014 Monthly Totals'
--           ,'/Driver Licensing/TR_Mon_014 Monthly Totals'
--           ,'*'
--           ,2
--           ,12)

		   --idcard to be sent to 
		   INSERT INTO [dbo].[ReportsVL]
           ([ReportName]
           ,[ReportPath]
           ,[AllowedRoles]
           ,[ReportSection]
           ,[Order])
     VALUES
           ('ID Cards to be sent to Print'
           ,'/Driver Licensing/ID Cards to be sent to Print'
           ,'*'
           ,2
           ,11)


		   INSERT INTO [dbo].[ReportsVL]
           ([ReportName] ,[ReportPath],[AllowedRoles] ,[ReportSection],[Order])
     VALUES
           ('New driver licences processed'
           ,'/Driver Licensing/New driver licences processed'
           ,'*'
           ,2,12)

		

		     INSERT INTO [dbo].[ReportsVL]
           ([ReportName] ,[ReportPath],[AllowedRoles] ,[ReportSection],[Order])
     VALUES
           ('RSS_Overview - By Date'
           ,'/Driver Licensing/RSS_Overview - By Date'
           ,'*'
           ,2,13)

		        INSERT INTO [dbo].[ReportsVL]
           ([ReportName] ,[ReportPath],[AllowedRoles] ,[ReportSection],[Order])
     VALUES
           ('TR_DRI_001 - Active Licenses'
           ,'/Driver Licensing/TR_DRI_001 - Active Licenses'
           ,'*'
           ,2,14)

		    INSERT INTO [dbo].[ReportsVL]
           ([ReportName] ,[ReportPath],[AllowedRoles] ,[ReportSection],[Order])
     VALUES
           ('TR_DRI_006 - Drivers by County Details'
           ,'/Driver Licensing/TR_DRI_006 - Drivers by County Details'
           ,'*'
           ,2,15)

		        INSERT INTO [dbo].[ReportsVL]
           ([ReportName] ,[ReportPath],[AllowedRoles] ,[ReportSection],[Order])
     VALUES
           ('TR_DRI_007 - Licenses per Area with CERTIFICATIONS'
           ,'/Driver Licensing/TR_DRI_007 - Licenses per Area with CERTIFICATIONS'
           ,'*'
           ,2,16)


------------SPSV--------------


 INSERT INTO [dbo].[ReportsVL]
           ([ReportName]
           ,[ReportPath]
           ,[AllowedRoles]
           ,[ReportSection]
           ,[Order])
     VALUES
           ('Portal Percentages'
           ,'/SPSV Online Services/PortalPercentage'
           ,'*'
           ,3
           ,5)

-----------------new folder Monthly reports-----------------------



INSERT INTO [dbo].[ReportVLSection]
           ([ReportVLSectionName])
     VALUES
           ('Monthly reports')



 INSERT INTO [dbo].[ReportsVL]
           ([ReportName]
           ,[ReportPath]
           ,[AllowedRoles]
           ,[ReportSection]
           ,[Order])
     VALUES
           ('Monthly Transaction Summary'
           ,'/Monthly Reports/Monthly Transaction Summary'
           ,'*'
           ,8
           ,1)

INSERT INTO [dbo].[ReportsVL]
           ([ReportName]
           ,[ReportPath]
           ,[AllowedRoles]
           ,[ReportSection]
           ,[Order])
     VALUES
           ('TR_MON_007 - Active Licenses by County (Primary Area only)'
           ,'/Monthly Reports/TR_MON_007 - Active Licenses by County (Primary Area only)'
           ,'*'
           ,8
           ,2)

		   INSERT INTO [dbo].[ReportsVL]
           ([ReportName]
           ,[ReportPath]
           ,[AllowedRoles]
           ,[ReportSection]
           ,[Order])
     VALUES
           ('TR_MON_014 - MonthlyTotals'
           ,'/Monthly Reports/TR_MON_014 - MonthlyTotals'
           ,'*'
           ,8
           ,3)



SELECT TOP (1000) [ReportId]
      ,[ReportName]
      ,[ReportPath]
      ,[AllowedRoles]
      ,[ReportSection]
      ,[Order]
  FROM [cabs_production].[dbo].[ReportsVL]


rollback


