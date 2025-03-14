USE [cabs_production]
GO

INSERT INTO [cabs_enf].[lkAuditItem]
   ([AuditItem]
   ,[Active]
   ,[ParentId]
   ,[PenaltyAmount]
   ,[LongName]
   ,[ShortName]
   ,[FineCode]
   ,[lkAuditItemTypeId]
   ,[CreatedBy]
   ,[CreatedOn]
   ,[ModifiedBy]
   ,[ModifiedOn]
   ,[IsSuitability]
   ,[IsRoadworthiness])
VALUES
   ('Failure to carry a cashless payment device',1,4,200,'Failure to carry a cashless payment device','Failure to carry a cashless payment device','D19',1,'opensky',getdate(),NULL,NULL, 1,0),
   ('Failure to accept a cashless payment',1,4,200,'Failure to accept a cashless payment','Failure to accept a cashless payment','D20',1,'opensky',getdate(),NULL,NULL, 0,0);
GO


