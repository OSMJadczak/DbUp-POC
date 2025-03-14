USE [authService]
GO

delete from [authService].[jwtauth].[ApplicationSettingsCredentials]
where
	ApplicationSettingsEntityId = 'B4CBD65B-2C6D-4A88-A1DF-7805D96875E5' and
	CredentialsEntityId = '8E6E1B30-6CB6-4B0E-90A2-FB0038026CDC'

delete from [authService].[jwtauth].[ApplicationSettings]
where Id = 'B4CBD65B-2C6D-4A88-A1DF-7805D96875E5'
