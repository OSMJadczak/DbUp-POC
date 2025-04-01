SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [person].[v_opv] AS 

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
	p.PersonId					        				as 'Id',
	ltrim(rtrim(p.CCSN))								as 'CCSN',
	ltrim(rtrim(p.PPSN))								as 'PPSN',
	pt.PersonType		        						as 'PersonType',
	ps.PersonStatus								        as 'PersonStatus',
	ltrim(rtrim(i.FirstName))							as 'FirstName',
	ltrim(rtrim(i.LastName))							as 'LastName',
	ltrim(rtrim(c.CompanyName))							as 'CompanyName',
	c.CompanyNumber     								as 'CompanyNumber',
	case pt.PersonType
		when 'Company' then c.TradingAs
		when 'Individual' then i.TradingAs	
	end										        	as 'TradingAs',
	i.DateOfBirth							        	as 'DateOfBirth',
	convert(varchar(50), STUFF((
            SELECT ',' + ltrim(rtrim(convert(varchar(50), phone.PhoneNumber)))
            FROM person.Phone phone with (nolock)
			where phone.PersonId=p.PersonId and phone.PhoneTypeId = 1
			order by phone.PhoneId
            FOR XML PATH('')
            ), 1, 1, '')) as 'MobilePhone',
	convert(varchar(50), STUFF((
            SELECT ',' + ltrim(rtrim(convert(varchar(50), phone.PhoneNumber)))
            FROM person.Phone phone with (nolock)
			where phone.PersonId=p.PersonId and phone.PhoneTypeId = 2
			order by phone.PhoneId
            FOR XML PATH('')
            ), 1, 1, '')) as 'OtherPhone',
	ltrim(rtrim(pe.Email))		    				as 'Email',
	ltrim(rtrim(pa.AddressLine1))					as 'AddressLine1',
	ltrim(rtrim(pa.AddressLine2))					as 'AddressLine2',
	ltrim(rtrim(pa.AddressLine3))					as 'AddressLine3',
	pa.Irish    									as 'Irish',
	ltrim(rtrim(pa.EirCode))						as 'Eircode',
	ltrim(rtrim(pcm.ContactMethod))					as 'PrefContactMethod',
	ltrim(rtrim(pa.Town))							as 'Town',
	ltrim(rtrim(pa.PostCode))						as 'PostCode',
	cc.CountyName								    as 'CountyName',
	ac.CountryName								    as 'CountryName',
	p.CreatedBy									    as 'CreatedBy',
	p.CreatedDate								    as 'CreatedOn',
	cte_Modified.ModifiedBy						    as 'ModifiedBy',	
	cte_Modified.ModifiedDate					    as 'ModifiedOn',
	STUFF((
            SELECT ',' + rtrim(convert(varchar(10), ds.SourceSystemId))
            FROM [person].[DataSource] ds with (nolock)
			where ds.PersonId=p.PersonId and ds.SourceSystemName = 'VLS'
			order by ds.SourceSystemId
            FOR XML PATH('')
            ), 1, 1, '') 'VLS_ID',
	STUFF((
            SELECT ',' + rtrim(convert(varchar(10), ds.ETLid))
            FROM [person].[DataSource] ds with (nolock)
			where ds.PersonId=p.PersonId and ds.SourceSystemName = 'VLS'
			order by ds.SourceSystemId
            FOR XML PATH('')
            ), 1, 1, '') 'VLS_ETLID',
	STUFF((
            SELECT ',' + rtrim(convert(varchar(10), ds.SourceSystemId))
            FROM [person].[DataSource] ds with (nolock)
			where ds.PersonId=p.PersonId and ds.SourceSystemName = 'DLS'
			order by ds.SourceSystemId
            FOR XML PATH('')
            ), 1, 1, '') 'DLS_ID',
	STUFF((
            SELECT ',' + rtrim(convert(varchar(10), ds.ETLid))
            FROM [person].[DataSource] ds with (nolock)
			where ds.PersonId=p.PersonId and ds.SourceSystemName = 'DLS'
			order by ds.SourceSystemId
            FOR XML PATH('')
            ), 1, 1, '') 'DLS_ETLID',
	STUFF((
            SELECT ',' + rtrim(convert(varchar(10), ds.SourceSystemId))
            FROM [person].[DataSource] ds with (nolock)
			where ds.PersonId=p.PersonId and ds.SourceSystemName = 'SK'
			order by ds.SourceSystemId
            FOR XML PATH('')
            ), 1, 1, '') 'SK_ID',
	STUFF((
            SELECT ',' + rtrim(convert(varchar(10), ds.ETLid))
            FROM [person].[DataSource] ds with (nolock)
			where ds.PersonId=p.PersonId and ds.SourceSystemName = 'SK'
			order by ds.SourceSystemId
            FOR XML PATH('')
            ), 1, 1, '') 'SK_ETLID',
	STUFF((
            SELECT ',' + rtrim(convert(varchar(10), ds.SourceSystemId))
            FROM [person].[DataSource] ds with (nolock)
			where ds.PersonId=p.PersonId and ds.SourceSystemName = 'S15'
			order by ds.SourceSystemId
            FOR XML PATH('')
            ), 1, 1, '') 'S15_ID',
	STUFF((
            SELECT ',' + rtrim(convert(varchar(10), ds.ETLid))
            FROM [person].[DataSource] ds with (nolock)
			where ds.PersonId=p.PersonId and ds.SourceSystemName = 'S15'
			order by ds.SourceSystemId
            FOR XML PATH('')
            ), 1, 1, '') 'S15_ETLID'

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
