BEGIN TRY
    BEGIN TRAN;

    WITH MappedFuels AS 
    (
        SELECT * FROM (
            VALUES
            -- URL: https://openskydata.atlassian.net/wiki/spaces/CLNTNTA/pages/3280470045/APPENDIX+A+-+Mapping+Fuel+Types
            -- Fuel types mapping between NVDF and CABS IDs as in Appendix above
            (1, 1), -- PETROL
            (2, 2), -- DIESEL
            (3, 3), -- ELECTRIC
            (4, 4), -- GAS
            (5, 5), -- STEAM
            (6, 6), -- PETROL & GAS
            (7, 14), -- Hybrid
            (8, 8), -- PETROL/ELECTRIC
            (9, 9), -- ETHANOL/PETROL
            (10, 17), -- DIESEL/ELECTRIC
            (11, 21), -- PLUG-IN HYBRID ELECTRIC
            (12, 10), -- TVO/PETROL
            (13, 7), -- UNKNOWN
            (14, 22), -- TVO
            (15, 15), -- DIESEL/PLUG-IN HYBRID ELECTRIC
            (16, 16), -- PETROL/PLUG-IN HYBRID ELECTRIC
            (17, 18), -- ETHANOL/DIESEL
            (18, 20), -- HYDROGEN
            (19, 19) -- DIESEL AND GAS
        ) AS T(NVDF_Id,CABS_Id)
    ),
	EngineData AS (
        SELECT 
			MF.NVDF_Id AS NvdfFuelType,
            MatVehicles.Id AS VehicleId,
            COALESCE(VMaster.EngineCapacity, 2000) AS EngineCapacity
        FROM 
            [cabs_production].[dbo].[VehicleMaster] VMaster
            LEFT JOIN [MAT].[mat].Vehicles MatVehicles ON VMaster.RegistrationNumber = MatVehicles.RegistrationNumber
			LEFT JOIN MappedFuels AS MF ON VMaster.FuelTypeId = MF.CABS_Id
    )
    INSERT INTO [MAT].[mat].[Engines] ([FuelType], [EngineCapacity], [VehicleId])
    SELECT 
        COALESCE(NvdfFuelType, 13),
        EngineCapacity,
        VehicleId
    FROM 
        EngineData ED
    WHERE 
        NOT EXISTS (
            SELECT 
                1 
            FROM 
                [MAT].[mat].[Engines] 
            WHERE 
                [VehicleId] = ED.VehicleId 
                AND [FuelType] = ED.NvdfFuelType
        );

    COMMIT;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK;
    DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
    RAISERROR('%s', 16, 1, @ErrorMessage);
END CATCH;