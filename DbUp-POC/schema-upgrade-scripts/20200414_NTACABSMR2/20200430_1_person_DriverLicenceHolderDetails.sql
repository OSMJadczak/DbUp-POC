USE [cabs_production]
GO

/****** Object:  View [person].[DriverLicenceHolderDetails]    Script Date: 4/30/2020 9:46:33 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



ALTER VIEW [person].[DriverLicenceHolderDetails] AS 

SELECT 
	p.PersonId									as 'PersonId',
	p.CCSN										as 'CCSN',
	p.PPSN										as 'PPSN',
	pt.PersonType								as 'PersonType',
	ps.PersonStatus								as 'PersonStatus',
	i.FirstName									as 'FirstName',
	i.LastName									as 'LastName',
	c.CompanyName								as 'CompanyName',
	c.CompanyNumber								as 'CompanyNumber',
	case pt.PersonType
		when 'Company' then c.TradingAs
		when 'Individual' then i.TradingAs	
	end											as 'TradingAs',
	i.DateOfBirth								as 'DateOfBirth',
	convert(varchar(50),
            (SELECT TOP 1 rtrim(convert(varchar(10), phone.PhoneNumber))
            FROM person.Phone phone with (nolock)
			where phone.PersonId=p.PersonId and phone.PhoneTypeId = 1
			order by phone.PhoneId
            )) as 'PhoneNo1',--'MobilePhone'
	convert(varchar(50), 
			(SELECT TOP 1 rtrim(convert(varchar(10), phone.PhoneNumber))
            FROM person.Phone phone with (nolock)
			where phone.PersonId=p.PersonId and phone.PhoneTypeId = 2
			order by phone.PhoneId
            )) as 'PhoneNo2', --'OtherPhone',
	pe.Email									as 'Email',
	pa.AddressLine1								as 'AddressLine1',
	pa.AddressLine2								as 'AddressLine2',
	pa.AddressLine3								as 'AddressLine3',
	pa.Irish									as 'Irish',
	pa.EirCode									as 'Eircode',
	pcm.ContactMethod							as 'PrefContactMethod',
	pa.Town										as 'Town',
	pa.PostCode									as 'PostCode',
	cc.CountyName								as 'CountyName',
	cc.CountyId									as 'CountyId',
	ac.CountryName								as 'CountryName',
	ac.CountryId								as 'CountryId',
	p.CreatedBy									as 'CreatedBy',
	p.CreatedDate									as 'CreatedOn',
	isnull(p.ModifiedBy, p.CreatedBy)			as 'ModifiedBy',
	isnull(p.ModifiedDate, p.CreatedDate)			as 'ModifiedOn'
	FROM [person].[Person] as p with (nolock)
		left join [person].[PersonType] pt with (nolock) on pt.PersonTypeId=p.PersonTypeId
		left join [person].[PersonStatus] ps with (nolock) on ps.PersonStatusId=p.PersonStatusId
		left join [person].[Individual] i with (nolock) on p.PersonId=i.PersonId
		left join [person].[Company] c with (nolock) on p.PersonId=c.PersonId
		left join [person].[Email] pe with (nolock) on p.PersonId=pe.PersonId
		left join [person].[Address] pa with (nolock) on p.PersonId=pa.PersonId
		left join [person].[County] cc with (nolock) on pa.CountyId=cc.CountyId
		left join [person].[Country] ac with (nolock) on cc.CountryId=ac.CountryId
		left join [person].[ContactMethod] pcm with (nolock) on p.ContactMethodId=pcm.ContactMethodId
		where EXISTS (select * from  dl.LicenceHolderMaster lhm where lhm.PersonId = p.PersonId)
GO


