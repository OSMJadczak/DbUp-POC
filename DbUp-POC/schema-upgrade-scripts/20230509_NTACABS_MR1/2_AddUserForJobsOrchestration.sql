
use cabs_production

BEGIN
DECLARE @userName nvarchar(256) = 'backgroundservice-jobs-orchestration'
DECLARE @password nvarchar(128) = 'uatosdsnat*1'
DECLARE @email nvarchar(256) = @userName + '@openskydata.com'
DECLARE @date datetime = GETDATE();
DECLARE @userId uniqueidentifier = NEWID();

EXEC [dbo].[aspnet_Membership_CreateUser]
					@ApplicationName = 'cabs',
					@UserName = @userName,
					@Password = @password,
					@PasswordSalt = 'XJKPtuAYG4OXopp9GZEEhg==',
					@Email = @email,
					@PasswordQuestion = NULL,
					@PasswordAnswer = NULL,
					@PasswordFormat = 0,
					@IsApproved = 1,
					@CurrentTimeUtc = @date,
					@UserId = @UserId OUTPUT


INSERT INTO [dbo].[aspnet_UsersInRoles]([UserId],[RoleId])
SELECT @UserId,[RoleId] FROM [cabs_production].[dbo].[aspnet_Roles]
	


update [cabs_production].[dbo].[aspnet_Membership]
SET [LastPasswordChangedDate] =  DATEADD(year, 100, GETDATE()),
	PasswordFormat  = 0
WHERE UserId=@UserId

END

