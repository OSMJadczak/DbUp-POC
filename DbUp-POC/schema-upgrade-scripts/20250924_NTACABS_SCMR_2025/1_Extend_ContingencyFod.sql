use cabs_production;

alter table dbo.ContingencyFod add LicenceTypeId int null;
alter table dbo.ContingencyFod add MaxVehicleEnteredFleet datetime not null default '2022-12-09';
alter table dbo.ContingencyFod add VehicleRegistrationYear int null;

insert into dbo.ContingencyFod 
(OriginalFodStartDate, OriginalFodEndDate, ExtensionMonths, CreatedBy, CreatedDate, LicenceTypeId, MaxVehicleEnteredFleet, VehicleRegistrationYear)
values 
('2025-01-01 00:00:00.000', '2025-12-31 23:59:59.000', 12, 'system', GETDATE(), 1, '2025-04-01', 2015)
