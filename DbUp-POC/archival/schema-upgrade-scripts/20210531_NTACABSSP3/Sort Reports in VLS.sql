begin tran 

  /****** Script for SelectTopNRows command from SSMS  ******/
SELECT [ReportsVL].* , rs.ReportVLSectionName
  FROM [cabs_production].[dbo].[ReportsVL]
  left join dbo.ReportVLSection rs on rs.ReportVLSectionId = ReportsVL.ReportSection




SELECT [ReportId],[ReportName],[ReportSection],
ROW_NUMBER()OVER (ORDER BY [ReportSection],[ReportName] asc) AS RN,
( ROW_NUMBER()OVER (ORDER BY [ReportSection],[ReportName] asc) -(select Count(*) from [dbo].[ReportsVL] rr where rr.ReportSection <= [ReportsVL].ReportSection -1 )  )AS RNA
into #AlphabeticalOrder
FROM [dbo].[ReportsVL]
where ReportSection is not null

update [dbo].[ReportsVL] 
set [Order] = ( select RNA from #AlphabeticalOrder a where a.ReportId =[ReportsVL].ReportId )


  /****** Script for SelectTopNRows command from SSMS  ******/
SELECT [ReportsVL].* , rs.ReportVLSectionName
  FROM [cabs_production].[dbo].[ReportsVL]
  left join dbo.ReportVLSection rs on rs.ReportVLSectionId = ReportsVL.ReportSection

  order by ReportSection, [Order]


rollback 