USE [cabs_production]
GO

/****** Object:  StoredProcedure [dbo].[GetDeadTimeOutDate_SelectByLicenceNumber]    Script Date: 6/16/2021 1:43:04 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Syed
-- Create date: 13/01/2014
-- Description:	    We need to get all VL holders whose licences are inactive-expired, but which are due to go into dead-timed-out status soon. 
--					Can you include in the report all vehicle licence holders whose licences will move into dead-timed out status .
-- =============================================
ALTER PROCEDURE [dbo].[GetDeadTimeOutDate_SelectByLicenceNumber]
	-- Add the parameters for the stored procedure here
	@LicenceNumber as varchar(20)
AS
BEGIN

DECLARE @LicenceRenewalPeriod int = (
    SELECT TOP 1 ParameterValue FROM SystemParameter where ParameterName = 'LicenceRenewalPeriod')

SELECT top 1 tab.* 
FROM
	(SELECT
	CONCAT(LStateMaster.LicenceStateMaster, '-', LState.LicenceState) AS LicenceState,
	LM.LicenceNumber,
	LM.LicenceExpiryDate,
	CASE 
		 WHEN
			(LM.LicenceExpiryDate>=CONVERT(datetime,'1-31-2013')) THEN DATEADD(year, @LicenceRenewalPeriod, LM.LicenceExpiryDate) --rule 1 
		 WHEN
			(LM.LicenceExpiryDate<CONVERT(datetime,'1-31-2013') and LM.LicenceExpiryDate>=CONVERT(datetime,'12-31-2008')) THEN '2014/01/31'
		 WHEN
			(LM.LicenceExpiryDate<CONVERT(datetime,'12-31-2008')) THEN DATEADD(year,5,LM.LicenceExpiryDate) --rule 3   
	END AS WILL_MOVE_TO_DEAD_TIMEOUT_DATE

	FROM LicenceMasterVL LM
	LEFT JOIN [dbo].[LicenceStateMaster] LStateMaster ON LM.LicenceStateMasterID = LStateMaster.LicenceStateMasterID
	LEFT JOIN [dbo].[LicenceState] LState ON LM.LicenceStateID = LState.LicenceStateID
	JOIN [dbo].[LicenceType] LType ON LM.LicenceTypeID = LType.LicenceTypeID
	JOIN [dbo].[LicenceHolderMaster] LHM ON LHM.LicenceHolderID = LM.LicenceHolderID
	LEFT JOIN [dbo].[County] CNT ON CNT.COUNTYID = LHM.COUNTYID
	WHERE LStateMaster.LicenceStateMasterID = 5 /*'INACTIVE'*/ AND (LState.LicenceStateID = 8 /*'Expired'*/  OR LState.LicenceStateID = 11 /*'Suspended'*/)
	) AS Tab
WHERE TAB.LicenceNumber=@LicenceNumber
ORDER BY tab.LicenceExpiryDate

END

GO


