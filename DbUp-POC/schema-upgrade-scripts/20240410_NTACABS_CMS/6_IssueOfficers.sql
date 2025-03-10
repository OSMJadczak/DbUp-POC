DROP VIEW [dbo].[vw_IssueOfficers]
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


    ALTER   VIEW [dbo].[vw_ProductionIssueOfficers] AS
	
    
    with c as (
		select distinct ud.UserId, ud.FullName, m.Email, u.UserName, cast(IIF(t.UnifiedName in ('Compliance', 'SGSComplianceOfficers'), 0, 1) as bit) as IsGardaUser from 
			dbo.aspnet_Users u 
			join cabs_production.cabs_cmo.UserDetails ud on u.UserId=ud.UserId
			join dbo.aspnet_Membership m ON u.UserId = m.UserId

			left join cms.TeamMembers tm on u.UserName = tm.Username
			left join cms.Teams t on t.Id = tm.TeamId


			left join aspnet_UsersInRoles uir on uir.UserId = u.UserId
			left join aspnet_Roles r on r.RoleId = uir.RoleId

		where 
			-- select NTA users or Garda users, but not both
			-- we prefer to select NTA users over Garda users (if exists both, we select NTA users)
			(t.UnifiedName in ('Compliance', 'SGSComplianceOfficers') and (r.LoweredRoleName is null or r.LoweredRoleName != 'garda')) or 
			(t.UnifiedName is null  and r.LoweredRoleName = 'garda')		
    ) 	
	select * from c as c where 
		(
			c.IsGardaUser = 0 and ((select count(cc.userid) from c as cc where c.UserId=cc.UserId group by cc.userid) = 2) or
			c.IsGardaUser = 0 and ((select count(cc.userid) from c as cc where c.UserId=cc.UserId group by cc.userid) = 1) or
			c.IsGardaUser = 1 and ((select count(cc.userid) from c as cc where c.UserId=cc.UserId group by cc.userid) = 1)
		)
GO
