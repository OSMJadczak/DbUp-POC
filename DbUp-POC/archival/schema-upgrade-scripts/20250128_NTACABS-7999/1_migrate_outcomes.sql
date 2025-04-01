update [cabs_production].[cms].[Cases] set [ComplianceOutcome]='AdviceGiven' 
where id in (select id from cabs_live.dbo.cases where case_resolutionfk=4) and ComplianceOutcome is not null

update [cabs_production].[cms].[Cases] set [ComplianceOutcome]='NotProceededWithComplainantUnwillingToPursue'
where id in (select id from cabs_live.dbo.cases where case_resolutionfk=7) and ComplianceOutcome is not null

update [cabs_production].[cms].[Cases] set [ComplianceOutcome]='NotProceededWithNoResponseFromComplainant'
where id in (select id from cabs_live.dbo.cases where case_resolutionfk=8) and ComplianceOutcome is not null

update [cabs_production].[cms].[Cases] set [ComplianceOutcome]='NotProceededWithNoEvidenceOfAnyOffence'
where id in (select id from cabs_live.dbo.cases where case_resolutionfk=9) and ComplianceOutcome is not null

update [cabs_production].[cms].[Cases] set [ComplianceOutcome]='NotProceededWithInsufficientEvidenceToPursue'
where id in (select id from cabs_live.dbo.cases where case_resolutionfk=10) and ComplianceOutcome is not null

update [cabs_production].[cms].[Cases] set [ComplianceOutcome]='ReferredGardai' 
where id in (select id from cabs_live.dbo.cases where case_resolutionfk=11) and ComplianceOutcome is not null

update [cabs_production].[cms].[Cases] set [ComplianceOutcome]='ReferredOther' 
where id in (select id from cabs_live.dbo.cases where case_resolutionfk=12) and ComplianceOutcome is not null

update [cabs_production].[cms].[Cases] set [ComplianceOutcome]='Advice'
where id in (select id from cabs_live.dbo.cases where case_resolutionfk=13) and ComplianceOutcome is not null