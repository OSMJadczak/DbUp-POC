ALTER TABLE [cabs_production].[cabs_enf].[SearchAudit]
ADD DriverUnknown bit null;

update [cabs_production].[cabs_enf].[SearchAudit] 
set DriverUnknown = 
CASE  
    WHEN LicenceDriverName is not null THEN 0 
    ELSE 1
END 

