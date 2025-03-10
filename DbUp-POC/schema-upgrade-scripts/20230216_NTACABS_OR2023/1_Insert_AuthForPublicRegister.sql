USE [authService]
GO

INSERT INTO [authService].[jwtauth].[ApplicationSettings] (
	[Id],
    [ApplicationName],
    [IsActive],
    [JWTSecretKey],
    [JWTTokenExpirationTime],
    [JWTValidAudience],
    [JWTValidIssuer],
    [ApplicationPassword])
VALUES (
	'4CD602AF-1836-41BE-B65E-EE7439839617',
	'publicRegister',
	1,
	'026ACDEB-2327-48C0-8A90-1C8619E146AF',
	720,
	'660B2923-2A3D-4455-8D09-ED1E24A05B46',
	'67AE3D48-5CEF-4538-B492-0632A656BB32',
	'04d31a99a948f85d69a673cea9b23430')

INSERT INTO [authService].[jwtauth].[ApplicationSettingsCredentials] (
	[ApplicationSettingsEntityId],
	[CredentialsEntityId])
VALUES (
	'4CD602AF-1836-41BE-B65E-EE7439839617',
	'8E6E1B30-6CB6-4B0E-90A2-FB0038026CDC')