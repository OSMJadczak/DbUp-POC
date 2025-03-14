USE cabs_production;

ALTER TABLE LicenceMasterVL
ADD PreBookingQueryRequired BIT NOT NULL DEFAULT 0;

ALTER TABLE LicenceMasterVLAudit
ADD PreBookingQueryRequired BIT NOT NULL DEFAULT 0;