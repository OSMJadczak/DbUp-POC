USE [cabs_production]
GO

/****** Object:  StoredProcedure [dbo].[BC01_RenewalFeesUpdates]    Script Date: 2021-06-14 14:43:55 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[BC01_RenewalFeesUpdates]
  (@phase int)
  AS
  BEGIN
    IF OBJECT_ID('tempdb..#newValuesTable') IS NOT NULL
        DROP TABLE #newValuesTable

    CREATE TABLE #newValuesTable
    (
        FeeId INT,
        Amount SMALLMONEY,
        Phase INT
    )
    INSERT into #newValuesTable(FeeId, Amount, Phase)
        values 

        -- ,Update on 1st July 2022 (phase 2):
        (15, 120,2),    --'Expired Licence 1 year'
        (19, 45,2),     --'Expired Licence 6 months'
        (36, 45,2),     --'Expired Licence WAV 1 year'
        (37, 7.50,2),   --'Expired Licence WAV 6 months'

		--Update on 1st January 2023 (phase 5):
        (1, 120, 5),     --'Renewal 1 year'
        (18, 45, 5),     --'Renewal 6 months'
        (42, 45, 5),     --'Renewal LAH 1 year'
        (43, 7.50, 5),   --'Renewal LAH 6 months'
        (38, 45, 5),     --'Renewal WAV 1 year'
        (39, 7.50, 5),   --'Renewal WAV 6 months'
        (15, 350, 5),    --'Expired Licence 1 year'
        (19, 175, 5),    --'Expired Licence 6 months'
        (36, 425, 5),    --'Expired Licence WAV 1 year'
        (37, 212.5, 5)   --'Expired Licence WAV 6 months'

        begin tran
            DECLARE @currentDate Date = GETDATE()
            UPDATE fees
            SET 
                FeeAmount = newFees.Amount,
                ModifiedDate = @currentDate,
                ModifiedBy = 'JOB'
            FROM [cabs_production].[dbo].[Fee] AS fees
            INNER JOIN #newValuesTable AS newFees  ON newFees.FeeId = fees.FeeId
                WHERE newFees.Phase = @phase

            DROP TABLE #newValuesTable
        commit tran
  END
GO
