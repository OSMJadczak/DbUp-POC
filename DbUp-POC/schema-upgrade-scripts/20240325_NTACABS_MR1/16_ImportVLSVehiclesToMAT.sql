BEGIN TRY
    BEGIN TRAN;

    INSERT INTO [MAT].[mat].[Vehicles]
    (
        [RegistrationNumber],
        [ChassisNumber],
        [MakeDescription],
        [ModelDescription],
        [BodyDescription],
        [ColourDescription],
        [SeatCount],
        [ManufactureYear],
        [EuCode],
        [FirstRegistrationDate],
        [FirstIrelandRegistrationDate],
        [VrtCode],
        [TypeApprovalNumber],
        [PermissibleMassGVW],
        [NctNumber],
        [NctIssueDate],
        [NctExpiryDate],
        [Co2NedcEmissions],
        [Co2WltpEmissions]
    )
    SELECT 
        RegistrationNumber,
        CASE WHEN VMaster.VIN IS NULL OR VMaster.VIN = '' THEN 'SB164ZEB10E002797' ELSE VMaster.VIN END,
        VMake.Make,
        VModel.Model,
        VBodyType.BodyType,
        VColour.Colour,
        NumberSeats,
        YearOfManufacture,
        'M1',
        RegistrationDateOrigin,
        RegistrationDateIreland,
        CASE WHEN VrtVehicleCategory IS NULL OR VrtVehicleCategory = '' THEN 'VRT Category A' ELSE VrtVehicleCategory END,
        CASE WHEN TypeApprovalNumber IS NULL OR TypeApprovalNumber = '' THEN 'E11*2001/116*0304*09' ELSE TypeApprovalNumber END,
        CASE WHEN PermissibleMassGvw IS NULL OR PermissibleMassGvw = '' THEN '2500' ELSE PermissibleMassGvw END,
        CASE WHEN NctSerialNumber IS NULL OR NctSerialNumber = '' THEN '620040398447' ELSE NctSerialNumber END,
        DATEADD(YEAR, 1, GETDATE()),
        DATEADD(DAY, -1, GETDATE()),
        NedcCo2Emission,
        WltpCo2Emission
    FROM 
        [cabs_production].[dbo].[VehicleMaster] VMaster
    JOIN 
        [cabs_production].[dbo].[VehicleMake] VMake ON VMaster.MakeID = VMake.MakeID
    JOIN 
        [cabs_production].[dbo].[VehicleModel] VModel ON VMaster.ModelID = VModel.ModelID
    JOIN 
        [cabs_production].[dbo].[VehicleBodyType] VBodyType ON VMaster.BodyTypeID = VBodyType.BodyTypeID
    JOIN 
        [cabs_production].[dbo].[VehicleColour] VColour ON VMaster.ColourID = VColour.ColourID
    WHERE 
        NOT EXISTS (
            SELECT 
                1 
            FROM 
                [MAT].[mat].[Vehicles] 
            WHERE 
                [RegistrationNumber] = VMaster.RegistrationNumber
        );

    COMMIT;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK;
    DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
    RAISERROR('%s', 16, 1, @ErrorMessage);
END CATCH;