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
	'B4CBD65B-2C6D-4A88-A1DF-7805D96875E5',
	'lettersService',
	1,
	'401B7823-A6E0-44D3-9E45-3FB75A2FB35A',
	720,
	'076C3BA4-0638-44AA-889E-B9B0E9533DD3',
	'26BA4248-2BDB-49E4-8212-AF59A4A274E5',
	'04d31a99a948f85d69a673cea9b23430')

INSERT INTO [authService].[jwtauth].[ApplicationSettingsCredentials] (
	[ApplicationSettingsEntityId],
	[CredentialsEntityId])
VALUES (
	'B4CBD65B-2C6D-4A88-A1DF-7805D96875E5',
	'8E6E1B30-6CB6-4B0E-90A2-FB0038026CDC')