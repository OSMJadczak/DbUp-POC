update [cabs_production].[cabs_cmo].[SystemMessage]
set MessageText = 'The password does not meet password complexity criteria: a minimum of 8 characters with 1 upper case letter, 1 lower case letter, 1 digit and 1 special character is required.'
where MessageCode = 11009 and MessageText = 'The password does not meet password complexity criteria: a minimum of 8 characters, with 1 letter and 1 number is required.'

update [cabs_production].[cabs_cmo].[SystemMessage]
set MessageText = '(ENG) The password does not meet password complexity criteria: a minimum of 8 characters with 1 upper case letter, 1 lower case letter, 1 digit and 1 special character is required.'
where MessageCode = 11009 and MessageText = '(ENG) The password does not meet password complexity criteria: a minimum of 8 characters, with 1 letter and 1 number is required.'
