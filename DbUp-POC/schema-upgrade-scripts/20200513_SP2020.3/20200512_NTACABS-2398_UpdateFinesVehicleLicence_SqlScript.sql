UPDATE f
	SET f.[VehicleLicenceNumber]=tmp.[LicenceNumber],
	    f.[InfoLicenceNumber]=tmp.[LicenceNumber] 
FROM [cabs_production].[cabs_enf].[Fines] as f
JOIN (
	SELECT [LicenceNumber], 
	case when SUBSTRING([LicenceNumber], 1, 1)='T' then replace([LicenceNumber], 'T', 'W')
		when SUBSTRING([LicenceNumber], 1, 1)='W' then replace([LicenceNumber], 'W', 'T')
	end as 'LicenceNumberOld'
	  FROM [cabs_production].[dbo].[Booking]
	  where [SystemProcessId]=17
	  and [bookingid] in (select [bookingid] from [cabs_production].[dbo].[VehicleInspections] where [TestResultId]=1)
	  and [CreatedDate] > '2019-03-23') as tmp 
ON f.[VehicleLicenceNumber]=tmp.[LicenceNumberOld] OR f.[InfoLicenceNumber]=tmp.[LicenceNumberOld]