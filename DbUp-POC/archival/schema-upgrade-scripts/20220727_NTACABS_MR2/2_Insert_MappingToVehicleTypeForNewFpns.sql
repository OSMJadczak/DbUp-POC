USE [cabs_production]
GO

DECLARE @D19 AS INT = (SELECT TOP 1 ID FROM [cabs_production].[cabs_enf].[lkAuditItem] WHERE [FineCode] = 'D19');
DECLARE @D20 AS INT = (SELECT TOP 1 ID FROM [cabs_production].[cabs_enf].[lkAuditItem] WHERE [FineCode] = 'D20');

INSERT INTO [cabs_production].[cabs_enf].[xrefVehicleTypeAuditItem] ([Active] ,[SortOrder] ,[VehicleTypeId] ,[lkAuditItemId])
VALUES (1, 1, 1, @D19),
	(1, 2, 1, @D20),
	(1, 1, 2, @D19),
	(1, 2, 2, @D20),
	(1, 1, 3, @D19),
	(1, 2, 3, @D20),
	(1, 1, 4, @D19),
	(1, 2, 4, @D20),
	(1, 1, 5, @D19),
	(1, 2, 5, @D20),
	(1, 1, 6, @D19),
	(1, 2, 6, @D20),
	(1, 1, 7, @D19),
	(1, 2, 7, @D20)