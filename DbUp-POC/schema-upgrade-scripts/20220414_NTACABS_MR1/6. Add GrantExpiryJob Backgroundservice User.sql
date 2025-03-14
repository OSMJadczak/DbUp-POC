update [dbo].[aspnet_Membership] set IsApproved = 'true' where UserId = (select UserId from [dbo].[aspnet_users] where UserName = 'backgroundservice2')

insert into [dbo].[aspnet_UsersInRoles] (UserId, RoleId) values
((select UserId from [dbo].[aspnet_users] where UserName = 'backgroundservice2'), (select RoleId from [dbo].[aspnet_Roles] where RoleName = 'Person View')),
((select UserId from [dbo].[aspnet_users] where UserName = 'backgroundservice2'), (select RoleId from [dbo].[aspnet_Roles] where RoleName = 'Person View Admin'))



use cabs_production

BEGIN
DECLARE @userName nvarchar(256) = 'backgroundservice10'
DECLARE @password nvarchar(128) = 'W4wxGKrco4RGk6yYy3nY/5I1JJs=' -- FOR PRODUCTION - set the correct live password!
DECLARE @email nvarchar(256) = 'backgroundservice'
DECLARE @date datetime = GETDATE();
DECLARE @userId uniqueidentifier = NEWID();

EXEC [dbo].[aspnet_Membership_CreateUser]
					@ApplicationName = 'cabs',
					@UserName = @userName,
					@Password = @password,
					@PasswordSalt = '4P5xaqOGHG90xTCTMm2zUg==',
					@Email = @email,
					@PasswordQuestion = NULL,
					@PasswordAnswer = NULL,
					@PasswordFormat = 1,
					@IsApproved = 1,
					@CurrentTimeUtc = @date,
					@UserId = @UserId OUTPUT


INSERT INTO [dbo].[aspnet_UsersInRoles]([UserId],[RoleId])
SELECT @UserId,[RoleId] FROM [cabs_production].[dbo].[aspnet_Roles]
	


update [cabs_production].[dbo].[aspnet_Membership]
SET [LastPasswordChangedDate] =  DATEADD(year, 100, GETDATE()),
	PasswordFormat = 1
WHERE UserId=@UserId

END

