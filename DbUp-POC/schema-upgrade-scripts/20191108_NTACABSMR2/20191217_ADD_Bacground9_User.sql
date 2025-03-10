DECLARE @date datetime = GETDATE();
DECLARE @UserId uniqueidentifier;
DECLARE @email nvarchar(50) = 'backgroundservice9';
											
DECLARE @defaultPassword nvarchar(100)= 'IL/qBi0MUyO4Q2MJQqhhe+fFddM=';
DECLARE @defaultSalt nvarchar(100) = 'nbHp6SW3P8e7G9x6LRb5Mw==';
DECLARE @applicationId uniqueidentifier = (SELECT TOP 1 ApplicationId 
											FROM aspnet_Applications 
											WHERE ApplicationName = 'cabs');		
		
EXEC [dbo].[aspnet_Membership_CreateUser]
			@ApplicationName = 'cabs',
			@UserName = @email,
			@Password = @defaultPassword,
			@PasswordSalt = @defaultSalt,
			@Email = @email,
			@PasswordQuestion = NULL,
			@PasswordAnswer = NULL,
			@IsApproved = 1,
			@CurrentTimeUtc = @date,
			@UserId = @UserId OUTPUT

EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles 'cabs',@email,'backgroundservice',@date
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles 'cabs',@email,'person view',@date		 