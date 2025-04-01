USE [cabs_production]
GO

ALTER TABLE [cabs_insp].[VehicleMasterDraft] 
ADD FuelTypeId tinyint null

ALTER TABLE [cabs_insp].[VehicleMasterDraft]  WITH CHECK ADD  CONSTRAINT [FK_VehicleMasterDraft_VehicleFuelType] FOREIGN KEY([FuelTypeId])
REFERENCES [dbo].[VehicleFuelType] ([FuelTypeId])
GO

ALTER TABLE [cabs_insp].[VehicleMasterDraft] CHECK CONSTRAINT [FK_VehicleMasterDraft_VehicleFuelType]
GO