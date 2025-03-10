USE [cabs_production]
GO

/****** Object:  View [dbo].[vw_ProductionIssueOfficers]    Script Date: 14/11/2023 11:05:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

	CREATE OR ALTER VIEW [dbo].[vw_ProductionIssueOfficers] AS
	
	select distinct u.UserId, u.FullName, m.Email from cabs_live.dbo.Case_TeamUsers tu
	join cabs_production.cabs_cmo.UserDetails u on tu.user_id=u.UserId
    JOIN dbo.aspnet_Membership m ON u.UserId = m.UserId
	where team_id=6 or team_id=16	

GO


