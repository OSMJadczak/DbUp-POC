
USE [authService]
GO

delete from [authService].[jwtauth].[ApplicationSettingsCredentials]
where ApplicationSettingsEntityId = '767e0377-9f21-44d9-acef-2f4934c6bc71'

delete from [authService].[jwtauth].[ApplicationSettings]
where Id = '767e0377-9f21-44d9-acef-2f4934c6bc71'
