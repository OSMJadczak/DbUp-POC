-- Note: do not use temp tables (#tableName), the connection cab be closed during deployment and the temp table will be dropped

-- for 19 script
select * into cabs_enf.tmp_FineNote from cabs_enf.FineNote

select * into cabs_enf.tmp_Fines from cabs_enf.Fines


