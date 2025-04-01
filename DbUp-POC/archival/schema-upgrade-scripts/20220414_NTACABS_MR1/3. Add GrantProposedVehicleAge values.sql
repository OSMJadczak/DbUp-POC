USE [Cabs_Live]
GO

INSERT INTO [dbo].[GrantProposedVehicleAge]
           ([GrantProposedAgeId]
           ,[GrantProposedAgeName]
           ,[GrantProposedAgeValue]
           ,[GrantType])
     VALUES
           (1, 'New (less than 3,000kms and 3 months old)',7500,'WAV'),
		   (2, 'Less than 1 year', 7000,'WAV'),
		   (3, 'Less than 2 years', 6000,'WAV'),
		   (4, 'Less than 3 years', 5000,'WAV'),
		   (5, 'Less than 4 years', 4000,'WAV'),
		   (6, 'Less than 5 years', 3000,'WAV'),
		   (7, 'Less than 6 years', 2500,'WAV'),
		   (8, 'New (less than 3,000kms and 3 months old)',7500,'eSPSV'),
		   (9, 'Less than 1 year', 6500,'eSPSV'),
		   (10, 'Less than 2 years', 5500,'eSPSV'),
		   (11, 'Less than 3 years', 4500,'eSPSV'),
		   (12, 'Less than 4 years', 3500,'eSPSV');


GO


