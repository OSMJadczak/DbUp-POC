USE [cabs_production]
GO

exec sp_rename 'cabs_spsv.IndustryUserDriverLicenceHolderMaster', '_ToDrop_IndustryUserDriverLicenceHolderMaster'
GO

exec sp_rename 'cabs_spsv.IndustryUserLicenceHolderMaster', '_ToDrop_IndustryUserLicenceHolderMaster'
GO

exec sp_rename 'cabs_spsv.IndustryUserDriverLicenceHolderMaster_migration', '_ToDrop_IndustryUserDriverLicenceHolderMaster_migration'
GO
