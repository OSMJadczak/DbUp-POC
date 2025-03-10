-- Note: do not use temp tables (#tableName), the connection cab be closed during deployment and the temp table will be dropped

-- for 3 script
select * into tmp_FineNotifications from cabs_enf.FineNotifications


