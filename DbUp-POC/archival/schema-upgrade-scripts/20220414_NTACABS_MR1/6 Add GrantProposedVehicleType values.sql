USE [Cabs_Live]
GO

INSERT INTO [dbo].[GrantProposedVehicleType] ([Name], [CreatedBy], [CreatedDate])
VALUES
	('BEV/FCEV', 'opensky', GETDATE()),
	('WAV VEV/FCEV', 'opensky', GETDATE()),
	('WAV PHEV', 'opensky', GETDATE())
GO