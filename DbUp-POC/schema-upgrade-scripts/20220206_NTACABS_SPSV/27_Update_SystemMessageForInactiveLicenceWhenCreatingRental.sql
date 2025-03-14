update [cabs_production].[cabs_cmo].[SystemMessage]
set MessageText = 'It is not possible to create a rental agreement for this Driver licence'
where MessageCode = 11059 and MessageText = 'This Licence is inactive, please contact the helpdesk for further information.'

update [cabs_production].[cabs_cmo].[SystemMessage]
set MessageText = '(ENG) It is not possible to create a rental agreement for this Driver licence'
where MessageCode = 11059 and MessageText = '(ENG) This Licence is inactive, please contact the helpdesk for further information.'
