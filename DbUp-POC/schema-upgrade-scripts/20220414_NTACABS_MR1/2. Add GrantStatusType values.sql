USE [Cabs_Live]
GO

INSERT INTO [dbo].[GrantStatusType]
           ([Type]
           ,[IsActive])
     VALUES
           ('Acknowledgement',0),
		   ('Appealed',1),
		   ('Auto-Rejected',1),
		   ('eSPSV-GOL issued', 1),
		   ('Incomplete',0),
		   ('Lapsed',1),
		   ('Technical Documentation Approved',1),
		   ('More Information Required',1),
		   ('New',1),
		   ('Paid',1),
		   ('Pending Payment',1),
		   ('Provisional Grant Offer',1),
		   ('Provisional Grant Offer Extended',1),
		   ('Rejected By NTA',1),
		   ('Withdrawn',1);

GO


