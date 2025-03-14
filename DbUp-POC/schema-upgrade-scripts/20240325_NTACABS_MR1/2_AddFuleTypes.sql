USE [cabs_production]
GO

BEGIN TRANSACTION;
GO

alter table dbo.VehicleFuelType alter column FuelType varchar(40) not null

SET IDENTITY_INSERT dbo.VehicleFuelType ON

insert into dbo.VehicleFuelType (FuelTypeId,FuelType,Active,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate) values (14, 'HYBRID', 1, 'System', GETDATE(), 'System', GETDATE())
insert into dbo.VehicleFuelType (FuelTypeId,FuelType,Active,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate) values (15, 'DIESEL/PLUG-IN HYBRID ELECTRIC', 1, 'System', GETDATE(), 'System', GETDATE())
insert into dbo.VehicleFuelType (FuelTypeId,FuelType,Active,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate) values (16, 'PETROL/PLUG-IN HYBRID ELECTRIC', 1, 'System', GETDATE(), 'System', GETDATE())
insert into dbo.VehicleFuelType (FuelTypeId,FuelType,Active,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate) values (17, 'DIESEL/ELECTRIC', 1, 'System', GETDATE(), 'System', GETDATE())
insert into dbo.VehicleFuelType (FuelTypeId,FuelType,Active,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate) values (18, 'ETHANOL/DIESEL', 1, 'System', GETDATE(), 'System', GETDATE())
insert into dbo.VehicleFuelType (FuelTypeId,FuelType,Active,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate) values (19, 'DIESEL AND GAS', 1, 'System', GETDATE(), 'System', GETDATE())
insert into dbo.VehicleFuelType (FuelTypeId,FuelType,Active,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate) values (20, 'HYDROGEN', 1, 'System', GETDATE(), 'System', GETDATE())
insert into dbo.VehicleFuelType (FuelTypeId,FuelType,Active,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate) values (21, 'PLUG-IN HYBRID ELECTRIC', 1, 'System', GETDATE(), 'System', GETDATE())
insert into dbo.VehicleFuelType (FuelTypeId,FuelType,Active,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate) values (22, 'TVO', 1, 'System', GETDATE(), 'System', GETDATE())
update dbo.VehicleFuelType set Active=0 where FuelTypeId = 13 -- PLUG-IN HYBRID
    

SET IDENTITY_INSERT dbo.VehicleFuelType OFF
GO

COMMIT;
GO