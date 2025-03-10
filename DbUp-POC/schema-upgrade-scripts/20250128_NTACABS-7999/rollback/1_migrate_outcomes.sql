-- rollback
-- old 'AdviceGiven'
update [cabs_production].[cms].[Cases] set [ComplianceOutcome]='InstructedAsToLegalRightsAndResponsibilities' 
where id in (select id from cabs_live.dbo.cases where case_resolutionfk=4) and ComplianceOutcome is not null

-- old 'NotProceededWithComplainantUnwillingToPursue'
update [cabs_production].[cms].[Cases] set [ComplianceOutcome]= 'ComplainantUnwillingToPursue'
where id in (select id from cabs_live.dbo.cases where case_resolutionfk=7) and ComplianceOutcome is not null

-- old 'NotProceededWithNoResponseFromComplainant'
update [cabs_production].[cms].[Cases] set [ComplianceOutcome]='NoResponseFromComplainant'
where id in (select id from cabs_live.dbo.cases where case_resolutionfk=8) and ComplianceOutcome is not null

-- old 'NotProceededWithNoEvidenceOfAnyOffence'
update [cabs_production].[cms].[Cases] set [ComplianceOutcome]='NoOffenceCommitted'
where id in (select id from cabs_live.dbo.cases where case_resolutionfk=9) and ComplianceOutcome is not null

-- old 'NotProceededWithInsufficientEvidenceToPursue'
update [cabs_production].[cms].[Cases] set [ComplianceOutcome]='InsufficientEvidenceToPursue'
where id in (select id from cabs_live.dbo.cases where case_resolutionfk=10) and ComplianceOutcome is not null

--old 'ReferredGardai'
update [cabs_production].[cms].[Cases] set [ComplianceOutcome]='TransferredGardaRemit' 
where id in (select id from cabs_live.dbo.cases where case_resolutionfk=11) and ComplianceOutcome is not null

-- old 'ReferredOther'
update [cabs_production].[cms].[Cases] set [ComplianceOutcome]='TransferredOtherAgencyRemit' 
where id in (select id from cabs_live.dbo.cases where case_resolutionfk=12) and ComplianceOutcome is not null

-- old 'Advice'
update [cabs_production].[cms].[Cases] set [ComplianceOutcome]='InstructedAsToLegalRightsAndResponsibilities'
where id in (select id from cabs_live.dbo.cases where case_resolutionfk=13) and ComplianceOutcome is not null