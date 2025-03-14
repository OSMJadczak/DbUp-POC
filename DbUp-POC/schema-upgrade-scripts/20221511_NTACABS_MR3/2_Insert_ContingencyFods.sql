USE [cabs_production]
GO

INSERT INTO [dbo].[ContingencyFod] 
	([OriginalFodStartDate], [OriginalFodEndDate], [ExtensionMonths], [CreatedBy], [CreatedDate])
VALUES
	('2020-03-13 00:00:00.000', '2020-12-31 23:59:59.000', 60, 'opensky', GETDATE()),
	('2021-01-01 00:00:00.000', '2021-12-31 23:59:59.000', 48, 'opensky', GETDATE()),
	('2022-01-01 00:00:00.000', '2022-12-31 23:59:59.000', 48, 'opensky', GETDATE()),
	('2023-01-01 00:00:00.000', '2023-12-31 23:59:59.000', 36, 'opensky', GETDATE()),
	('2024-01-01 00:00:00.000', '2024-12-31 23:59:59.000', 36, 'opensky', GETDATE())
GO