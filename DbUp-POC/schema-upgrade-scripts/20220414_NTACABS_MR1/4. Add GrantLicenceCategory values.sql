USE [Cabs_Live]
GO

INSERT INTO [dbo].[GrantLicenceCategory]
           ([GrantLicenceCategoryName]
           ,[GrantTypeID]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[ModifiedBy]
           ,[ModifiedDate])
     VALUES
           ('New Licence','WAV','migration',getdate(), 'migration',getdate()),
           ('Change of Vehicle','WAV','migration',getdate(), 'migration',getdate()),
           ('Exchange to WAV','WAV','migration',getdate(), 'migration',getdate()),
           ('New Licence','eSPSV','migration',getdate(), 'migration',getdate()),
           ('Change of Vehicle','eSPSV','migration',getdate(), 'migration',getdate()),
           ('Scrappage/End of Life','eSPSV','migration',getdate(), 'migration',getdate());


GO


