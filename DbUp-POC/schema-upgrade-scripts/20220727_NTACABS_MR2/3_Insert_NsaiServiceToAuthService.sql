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
	'C5CFFE98-624B-4604-8D4B-DC2682775334',
	'nsaiservice',
	1,
	'620AD4F2-2AEA-418A-A312-1FB5E71DA29E',
	720,
	'CA561B45-8738-4F56-B383-D5B67B342774',
	'CE9CEB1F-CC5A-490C-8F1C-99A715A951D3',
	'04d31a99a948f85d69a673cea9b23430')

INSERT INTO [authService].[jwtauth].[ApplicationSettingsCredentials] (
	[ApplicationSettingsEntityId],
	[CredentialsEntityId])
VALUES (
	'C5CFFE98-624B-4604-8D4B-DC2682775334',
	'8E6E1B30-6CB6-4B0E-90A2-FB0038026CDC')