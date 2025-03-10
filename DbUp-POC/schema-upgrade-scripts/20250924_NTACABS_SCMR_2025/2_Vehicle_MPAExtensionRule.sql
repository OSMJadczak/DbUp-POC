
use cabs_production;

alter table dbo.VehicleMaster add MPAExtensionRule int default 0;

-- set MPA Rule 2025 (reg date in 2015, FOD in 2025)
update  v
	set v.MPAExtensionRule=1
from dbo.VehicleMaster v
left join dbo.LicenceMasterVL vl on vl.RegistrationNumber=v.RegistrationNumber
where 
	v.RegistrationDate between '2015-01-01' and '2015-12-31'
	and vl.licencetypeid=1 
	and vl.LicenceStateMasterId in (4,5) -- 4-Active, 5-Inactive
	-- will never happened: as long as we have licence type condition (new licences with taxi-type are disabled)
	--and (vl.licencestateid <> 10 or vl.LicenceStateId is null) -- Exclude: Conditional offer for 5-Inactive
	and vl.FinalOperationDate between '2025-01-01' and '2025-12-31'
