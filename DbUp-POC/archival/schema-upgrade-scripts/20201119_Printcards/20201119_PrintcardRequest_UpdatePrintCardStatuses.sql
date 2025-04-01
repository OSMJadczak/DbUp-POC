USE [cabs_production]
GO

UPDATE  [cabs_production].[dl].[PrintcardRequest] Set PrintcardStatusId = 3 where DespatchDate is not null and PrintcardStatusId = 2