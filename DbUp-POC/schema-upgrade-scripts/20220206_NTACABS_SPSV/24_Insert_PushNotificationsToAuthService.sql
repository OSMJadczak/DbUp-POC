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
	'F72F9B19-FD4B-44EA-B4D0-4444F645312B',
	'pushNotifications',
	1,
	'ABC90A61-FA99-4D74-9A81-896FCB4B09E4',
	720,
	'B9ED165B-B2DB-4219-AD94-C1211952B2FE',
	'A21C7AFF-5212-4209-BA33-2BD70C1379A5',
	'04d31a99a948f85d69a673cea9b23430')

INSERT INTO [authService].[jwtauth].[ApplicationSettingsCredentials] (
	[ApplicationSettingsEntityId],
	[CredentialsEntityId])
VALUES (
	'F72F9B19-FD4B-44EA-B4D0-4444F645312B',
	'8E6E1B30-6CB6-4B0E-90A2-FB0038026CDC')