USE cabs_production;

IF COL_LENGTH('cabs_dck.DriverCheckReport','IsCompliment') IS NULL
BEGIN
    ALTER TABLE cabs_dck.DriverCheckReport
    ADD IsCompliment BIT NULL;
END
ELSE
    PRINT 'Column cabs_dck.DriverCheckReport.IsCompliment exist'