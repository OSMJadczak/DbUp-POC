use cabs_production;

alter table dbo.ContingencyFod drop LicenceTypeId;
alter table dbo.ContingencyFod drop MaxVehicleEnteredFleet;
alter table dbo.ContingencyFod drop VehicleRegistrationYear;

delete from dbo.ContingencyFod where 
	OriginalFodStartDate = '2025-01-01 00:00:00.000' and 
	OriginalFodEndDate = '2025-12-31 23:59:59.000' and 
	ExtensionMonths = 12 and 
	CreatedBy = 'system' and 
	LicenceTypeId = 1 and 
	MaxVehicleEnteredFleet = '2025-04-01' and 
	VehicleRegistrationYear = 2015

