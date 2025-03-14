USE [cabs_production]
GO

/****** Object:  View [person].[v_opv_marshaller]    Script Date: 4/17/2020 1:15:47 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [person].[v_opv_marshaller] AS 

with cte_Modified as (
select ROW_NUMBER() OVER (PARTITION BY PersonId order by Modifieddate desc) 'RankId', * from (
	select 'Person' 'Source', personid, isnull(ModifiedDate, CreatedDate) 'ModifiedDate', isnull(ModifiedBy, CreatedBy) 'ModifiedBy' FROM [person].[Person] with (nolock)
	union all
	select 'Individual' 'Source', personid, isnull(ModifiedDate, CreatedDate) 'ModifiedDate', isnull(ModifiedBy, CreatedBy) 'ModifiedBy' FROM [person].[Individual] with (nolock)
	union all
	select 'Company' 'Source', personid, isnull(ModifiedDate, CreatedDate) 'ModifiedDate', isnull(ModifiedBy, CreatedBy) 'ModifiedBy' FROM [person].[Company] with (nolock)
	union all
	select 'Address' 'Source', personid, isnull(ModifiedDate, CreatedDate) 'ModifiedDate', isnull(ModifiedBy, CreatedBy) 'ModifiedBy' FROM [person].[Address] with (nolock)
	union all
	select 'Email' 'Source', personid, isnull(ModifiedDate, CreatedDate) 'ModifiedDate', isnull(ModifiedBy, CreatedBy) 'ModifiedBy' FROM [person].[Email] with (nolock)
	union all
	select 'Company' 'Source', personid, isnull(ModifiedDate, CreatedDate) 'ModifiedDate', isnull(ModifiedBy, CreatedBy) 'ModifiedBy' FROM [person].[Address] with (nolock)
	union all
	select 'PhoneMobile' 'Source', personid, isnull(ModifiedDate, CreatedDate) 'ModifiedDate', isnull(ModifiedBy, CreatedBy) 'ModifiedBy' FROM person.phone with (nolock) where PhoneTypeId = 1 
	union all
	select 'PhoneOther' 'Source', personid, isnull(ModifiedDate, CreatedDate) 'ModifiedDate', isnull(ModifiedBy, CreatedBy) 'ModifiedBy' FROM person.phone with (nolock) where PhoneTypeId = 2 
) ds
)
 
SELECT
    p.PersonId                                    as 'Id',
    ltrim(rtrim(p.CCSN))                                        as 'CCSN',
    ltrim(rtrim(p.PPSN))                                        as 'PPSN',
    pt.PersonType                                as 'PersonType',
    ps.PersonStatus                                as 'PersonStatus',
    ltrim(rtrim(i.FirstName))                                    as 'FirstName',
    ltrim(rtrim(i.LastName))                                    as 'LastName',
    ltrim(rtrim(c.CompanyName))                                as 'CompanyName',
    c.CompanyNumber                                as 'CompanyNumber',
    case pt.PersonType
        when 'Company' then c.TradingAs
        when 'Individual' then i.TradingAs    
    end                                            as 'TradingAs',
    i.DateOfBirth                                as 'DateOfBirth',
    (SELECT TOP 1 ltrim(rtrim(phone.PhoneNumber))
		FROM person.Phone phone with (nolock)
		where phone.PersonId=p.PersonId and phone.PhoneTypeId = 1
		order by phone.PhoneId) as 'MobilePhone',
    (SELECT TOP 1 ltrim(rtrim(phone.PhoneNumber))
            FROM person.Phone phone with (nolock)
            where phone.PersonId=p.PersonId and phone.PhoneTypeId = 2
            order by phone.PhoneId) as 'OtherPhone',
    ltrim(rtrim(pe.Email))                                    as 'Email',
    ltrim(rtrim(pa.AddressLine1))                                as 'AddressLine1',
    ltrim(rtrim(pa.AddressLine2))                                as 'AddressLine2',
    ltrim(rtrim(pa.AddressLine3))                                as 'AddressLine3',
    pa.Irish                                    as 'Irish',
    ltrim(rtrim(pa.EirCode))                                    as 'Eircode',
    ltrim(rtrim(pcm.ContactMethod))                            as 'PrefContactMethod',
    CAST(pcm.ContactMethodId AS int)                           as 'PrefContactMethodId',
    case pcm.ContactMethod
        when 'Email' then CAST(1 AS BIT)
        else CAST(0 AS BIT)
    end                                            as 'EmailOptIn',
    case pcm.ContactMethod
        when 'POST' then CAST(1 AS BIT)
        else CAST(0 AS BIT)
    end                                            as 'MailOptIn',
    case p.PersonStatusId
        when 2 then CAST(1 AS BIT)
        when 3 then CAST(1 AS BIT)
        else CAST(0 AS BIT)
    end                                            as 'DeceasedYn',
    ltrim(rtrim(pa.Town))                                        as 'Town',
    ltrim(rtrim(pa.PostCode))                                    as 'PostCode',
	cc.CountyId										as 'CountyId',
    cc.CountyName                                as 'CountyName',
	ac.CountryId									as 'CountryId',
    ac.CountryName                                as 'CountryName',
    p.CreatedBy                                    as 'CreatedBy',
    p.CreatedDate                                    as 'CreatedOn',
    cte_Modified.ModifiedBy						as 'ModifiedBy',	
	cte_Modified.ModifiedDate					as 'ModifiedOn'
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
		left join cte_Modified  on cte_Modified.PersonId=p.PersonId and RankId=1
GO


