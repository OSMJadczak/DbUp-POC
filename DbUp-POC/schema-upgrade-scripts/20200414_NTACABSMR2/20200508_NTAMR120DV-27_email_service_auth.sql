USE [authService]
GO

INSERT INTO [jwtauth].[ApplicationSettings]
           ([Id]
           ,[ApplicationName]
           ,[IsActive]
           ,[JWTSecretKey]
           ,[JWTTokenExpirationTime]
           ,[JWTValidAudience]
           ,[JWTValidIssuer]
           ,[ApplicationPassword])
VALUES
           ('f2275d88-fb09-46b2-a4e8-8746d33955a9'
           ,'EmailService'
           ,1
           ,'7b913f92-4ee5-464e-b198-0ab2b7e5893e'
           ,720
           ,'1b107864-ce2a-4023-ab80-5e33506beb79'
           ,'4bf1cefe-5304-4f5f-a3db-f8a1a8c03c9f'
           ,'04d31a99a948f85d69a673cea9b23430')
		   
INSERT INTO [jwtauth].[ApplicationSettingsCredentials]
           ([ApplicationSettingsEntityId]
           ,[CredentialsEntityId])
VALUES
           ('f2275d88-fb09-46b2-a4e8-8746d33955a9'
           ,'65275221-A826-48AD-87E8-25B888CB872A'),
           ('f2275d88-fb09-46b2-a4e8-8746d33955a9'
           ,'8E6E1B30-6CB6-4B0E-90A2-FB0038026CDC')
GO


