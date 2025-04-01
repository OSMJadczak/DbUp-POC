DECLARE @date datetime = GETDATE();
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles 'cabs','icasb_user','backgroundservice',@date

-- CAN BE CHECKED BY RUNNING THE FOLLOWING QUERY
select r.RoleName, u.UserName, r.LoweredRoleName 
from [cabs_production].[dbo].[aspnet_Membership] as m
left join [cabs_production].[dbo].[aspnet_Users] u on u.UserId = m.UserId
left join [cabs_production].[dbo].[aspnet_UsersInRoles] ur on ur.UserId = u.UserId
LEFT join [cabs_production].[dbo].[aspnet_Roles]  r on ur.RoleId = r.RoleId
WHERE u.UserName = 'icasb_user'and r.LoweredRoleName = 'backgroundservice'