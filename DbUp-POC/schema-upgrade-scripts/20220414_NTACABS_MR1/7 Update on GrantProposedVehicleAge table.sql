USE [Cabs_Live]
GO

ALTER TABLE [dbo].[GrantProposedVehicleAge]
ADD GrantProposedVehicleTypeId INT;

ALTER TABLE [dbo].[GrantProposedVehicleAge]
ADD FOREIGN KEY (GrantProposedVehicleTypeId) REFERENCES dbo.GrantProposedVehicleType(Id);

ALTER TABLE [dbo].[GrantProposedVehicleAge]
ADD GrantLicenceCategoryId INT;

ALTER TABLE [dbo].[GrantProposedVehicleAge]
ADD FOREIGN KEY (GrantLicenceCategoryId) REFERENCES dbo.GrantLicenceCategory(Id);
GO

update [dbo].[GrantProposedVehicleAge] set [GrantProposedVehicleTypeId]=3, [GrantLicenceCategoryId]=4 where [GrantProposedAgeId] in (8,9,10,11,12)
GO

INSERT INTO [dbo].[GrantProposedVehicleAge]
           ([GrantProposedAgeId]
           ,[GrantProposedAgeName]
           ,[GrantProposedAgeValue]
           ,[GrantType]
		   ,[GrantProposedVehicleTypeId]
		   ,[GrantLicenceCategoryId])
     VALUES

		   (13,'New (less than 3,000kms and 3 months old)',7500,'eSPSV',3,5),
		   (14,'Less than 1 year', 6500,'eSPSV',3,5),
		   (15,'Less than 2 years', 5500,'eSPSV',3,5),
		   (16,'Less than 3 years', 4500,'eSPSV',3,5),
		   (17,'Less than 4 years', 3500,'eSPSV',3,5),
		   (18,'New (less than 3,000kms and 3 months old)',12500,'eSPSV',2,4),
		   (19,'Less than 1 year', 11500,'eSPSV',2,4),
		   (20,'Less than 2 years', 10500,'eSPSV',2,4),
		   (21,'Less than 3 years', 9500,'eSPSV',2,4),
		   (22,'Less than 4 years', 8500,'eSPSV',2,4),
		   (23,'New (less than 3,000kms and 3 months old)',12500,'eSPSV',2,5),
		   (24,'Less than 1 year', 11500,'eSPSV',2,5),
		   (25,'Less than 2 years', 10500,'eSPSV',2,5),
		   (26,'Less than 3 years', 9500,'eSPSV',2,5),
		   (27,'Less than 4 years', 8500,'eSPSV',2,5),
		   (28,'New (less than 3,000kms and 3 months old)',10000,'eSPSV',1,4),
		   (29,'Less than 1 year', 9000,'eSPSV',1,4),
		   (30,'Less than 2 years', 8000,'eSPSV',1,4),
		   (31,'Less than 3 years', 7000,'eSPSV',1,4),
		   (32,'Less than 4 years', 6000,'eSPSV',1,4),
		   (33,'New (less than 3,000kms and 3 months old)',10000,'eSPSV',1,5),
		   (34,'Less than 1 year', 9000,'eSPSV',1,5),
		   (35,'Less than 2 years', 8000,'eSPSV',1,5),
		   (36,'Less than 3 years', 7000,'eSPSV',1,5),
		   (37,'Less than 4 years', 6000,'eSPSV',1,5),
		   	(38,'New (less than 3,000kms and 3 months old)',15000,'eSPSV',3,6),
		   (39,'Less than 1 year', 13000,'eSPSV',3,6),
		   (40,'Less than 2 years', 11000,'eSPSV',3,6),
		   (41,'Less than 3 years', 9000,'eSPSV',3,6),
		   (42,'Less than 4 years', 7000,'eSPSV',3,6),
		   (43,'New (less than 3,000kms and 3 months old)',25000,'eSPSV',2,6),
		   (44,'Less than 1 year', 23000,'eSPSV',2,6),
		   (45,'Less than 2 years', 21000,'eSPSV',2,6),
		   (46,'Less than 3 years', 19000,'eSPSV',2,6),
		   (47,'Less than 4 years', 17000,'eSPSV',2,6),
		   (48,'New (less than 3,000kms and 3 months old)',20000,'eSPSV',1,6),
		   (49,'Less than 1 year', 18000,'eSPSV',1,6),
		   (50,'Less than 2 years', 16000,'eSPSV',1,6),
		   (51,'Less than 3 years', 14000,'eSPSV',1,6),
		   (52,'Less than 4 years', 12000,'eSPSV',1,6);
GO