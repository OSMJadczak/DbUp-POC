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
	'767e0377-9f21-44d9-acef-2f4934c6bc71',
	'nvdfApi',
	1,
	'5c59887c-c562-4afb-bb46-4db015404d48',
	720,
	'a73dddcb-733d-4d52-bb71-9bca9cc36ca2',
	'ac3caf99-7fb7-4efa-9fa2-1f71953bcc96',
	'04d31a99a948f85d69a673cea9b23430')

INSERT INTO [authService].[jwtauth].[ApplicationSettingsCredentials] (
	[ApplicationSettingsEntityId],
	[CredentialsEntityId])
VALUES (
	'767e0377-9f21-44d9-acef-2f4934c6bc71',
	'8E6E1B30-6CB6-4B0E-90A2-FB0038026CDC')
