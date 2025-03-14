USE [Cabs_Live]
GO

DELETE FROM [dbo].[GrantStatusType]
WHERE Type = 'eSPSV-GOL issued'

INSERT INTO [dbo].[GrantStatusType]
           ([Type]
           ,[IsActive])
     VALUES
		   ('eSPSV - GOL Issued', 1),
		   ('eSPSV - GOL Completed', 1)

GO


