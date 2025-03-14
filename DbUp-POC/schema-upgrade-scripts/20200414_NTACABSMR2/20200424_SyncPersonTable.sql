USE [cabs_production]
GO

/****** Object:  StoredProcedure [cabs_cmo].[SyncPersonTable]    Script Date: 4/24/2020 3:25:50 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



ALTER PROCEDURE [cabs_cmo].[SyncPersonTable]
AS
BEGIN
	CREATE TABLE #Temp (
		Ppsn VARCHAR(20)
		,ModifiedDate DATETIME
		,ModifiedBy NVARCHAR(20)
		,FirstName NVARCHAR(50)
		,LastName NVARCHAR(50)
		,Town NVARCHAR(50)
		,AddressLine1 NVARCHAR(50)
		,AddressLine2 NVARCHAR(50)
		,AddressLine3 NVARCHAR(50)
		,CountyID INT
		,PostCode VARCHAR(40)
		,HomeNumber VARCHAR(40)
		,MobileNumber VARCHAR(40)
		,Email NVARCHAR(50)
		,DateOfBirth DATETIME
		,IrishLanguageAddress BIT
		,CountryID INT
		,Source VARCHAR(20)
		)

	INSERT INTO #Temp
	SELECT x3.Ppsn
		,x3.ModifiedDate
		,x3.ModifiedBy
		,x3.FirstName
		,x3.LastName
		,x3.Town
		,x3.AddressLine1
		,x3.AddressLine2
		,x3.AddressLine3
		,x3.CountyId
		,x3.PostCode
		,x3.PhoneNo1
		,x3.PhoneNo2
		,x3.Email
		,x3.DateOfBirth
		,x3.IrishLanguageAddress
		,x3.CountryId
		,x2.Source
	FROM (
		SELECT x1.Ppsn
			,x1.x AS Source
			,MAX(x1.ModifiedDate) AS Modified
		FROM (
			SELECT lhm.Ppsn
				,lhm.ModifiedDate
				,'production' AS x
			FROM cabs_production.dbo.LicenceHolderMaster lhm
			
			UNION
			
			SELECT lhm.Ppsn
				,lhm.ModifiedDate
				,'live' AS x
			FROM cabs_live.dbo.LicenceHolderMaster lhm
			) x1
		GROUP BY x1.Ppsn
			,x1.x
		) x2
	INNER JOIN (
		SELECT lhm.Ppsn
			,lhm.ModifiedDate
			,lhm.ModifiedBy
			,lhm.FirstName
			,lhm.LastName
			,lhm.Town
			,lhm.AddressLine1
			,lhm.AddressLine2
			,lhm.AddressLine3
			,lhm.CountyId
			,lhm.PostCode
			,lhm.PhoneNo1
			,lhm.PhoneNo2
			,lhm.Email
			,lhm.DateOfBirth
			,lhm.IrishLanguageAddress
			,lhm.CountryId
		FROM cabs_production.dbo.LicenceHolderMaster lhm
		
		UNION
		
		SELECT lhm.Ppsn
			,lhm.ModifiedDate
			,lhm.ModifiedBy
			,lhm.FirstName
			,lhm.LastName
			,lhm.Town
			,lhm.AddressLine1
			,lhm.AddressLine2
			,lhm.AddressLine3
			,lhm.CountyId
			,lhm.PostCode
			,lhm.PhoneNo1
			,lhm.PhoneNo2
			,lhm.Email
			,lhm.DateOfBirth
			,NULL
			,NULL
			,NULL
		FROM cabs_live.dbo.LicenceHolderMaster lhm
		) x3 ON x2.Ppsn = x3.Ppsn
		AND (
			x2.Modified = x3.ModifiedDate
			OR ISNULL(x2.Modified, NULL) = 1
			OR ISNULL(x3.ModifiedDate, NULL) = 1
			)

	DECLARE db_cursor CURSOR FAST_FORWARD
	FOR
	SELECT person.PPSN
		,person.ModifiedDate
	FROM [cabs_production].[cabs_cmo].Person person
	ORDER BY ID DESC;

	DECLARE @ppsn VARCHAR(20);
	DECLARE @modified DATETIME;
	DECLARE @unionPersonFirstName VARCHAR(20);
	DECLARE @unionPersonLastName VARCHAR(20);
	DECLARE @unionModifiedBy NVARCHAR(20);
	DECLARE @unionTown NVARCHAR(50);
	DECLARE @unionAddressLine1 NVARCHAR(50);
	DECLARE @unionAddressLine2 NVARCHAR(50);
	DECLARE @unionAddressLine3 NVARCHAR(50);
	DECLARE @unionCountyID INT;
	DECLARE @unionCountryID INT;
	DECLARE @unionPostCode VARCHAR(40);
	DECLARE @unionHomeNumber VARCHAR(40);
	DECLARE @unionMobileNumber VARCHAR(40);
	DECLARE @unionEmail NVARCHAR(50);
	DECLARE @unionDateOfBirth DATETIME;
	DECLARE @unionIrishLanguageAddress BIT;
	DECLARE @unionPpsn VARCHAR(20);
	DECLARE @unionModified DATETIME;
	DECLARE @unionSource VARCHAR(20);

	OPEN db_cursor;

	FETCH NEXT
	FROM db_cursor
	INTO @ppsn
		,@modified;

	WHILE @@FETCH_STATUS = 0
	BEGIN -- while
		--PRINT 'Start next item';
		BEGIN TRY
			BEGIN TRANSACTION

			IF EXISTS (
					SELECT *
					FROM #Temp
					WHERE PPSN = @ppsn
						AND ModifiedDate > @modified
					)
			BEGIN
				--PRINT 'Updating item'
				SELECT TOP 1 @unionPersonFirstName = TEMP.FirstName
					,@unionPersonLastName = TEMP.LastName
					,@unionCountryID = TEMP.CountryID
					,@unionCountyID = TEMP.CountyID
					,@unionAddressLine1 = TEMP.AddressLine1
					,@unionAddressLine2 = TEMP.AddressLine2
					,@unionAddressLine3 = TEMP.AddressLine3
					,@unionTown = TEMP.Town
					,@unionDateOfBirth = TEMP.DateOfBirth
					,@unionEmail = TEMP.Email
					,@unionHomeNumber = TEMP.HomeNumber
					,@unionMobileNumber = TEMP.MobileNumber
					,@unionModifiedBy = TEMP.ModifiedBy
					,@unionIrishLanguageAddress = TEMP.IrishLanguageAddress
					,@unionPostCode = TEMP.PostCode
					,@unionPpsn = TEMP.Ppsn
					,@unionModified = TEMP.ModifiedDate
					,@unionSource = TEMP.Source
				FROM #Temp AS TEMP
				WHERE TEMP.Ppsn = @ppsn
				ORDER BY TEMP.ModifiedDate DESC

				IF (@unionCountyID > 26)
					SET @unionCountyID = NULL;-- Workaround for [cabs_live.County] and [cabs_production.County] are not syncronized

				DECLARE @resultMobile VARCHAR(40)
					,@resultHome VARCHAR(40);

				UPDATE [cabs_production].[cabs_cmo].[Person]
				SET ModifiedDate = GETDATE()
					,FirstName = @unionPersonFirstName
					,LastName = @unionPersonLastName
					,Town = @unionTown
					,AddressLine1 = @unionAddressLine1
					,AddressLine2 = @unionAddressLine2
					,AddressLine3 = @unionAddressLine3
					,CountyID = @unionCountyID
					,ModifiedBy = 'Sync job'
					,PostCode = @unionPostCode
					,Email = @unionEmail
					,DateOfBirth = @unionDateOfBirth
				WHERE PPSN = @ppsn;

				IF (@unionCountryID != NULL)
					UPDATE [cabs_production].[cabs_cmo].[Person]
					SET CountryID = @unionCountryID
					WHERE PPSN = @ppsn

				IF (@unionIrishLanguageAddress != NULL)
					UPDATE [cabs_production].[cabs_cmo].[Person]
					SET IrishLanguageAddress = @unionIrishLanguageAddress
					WHERE PPSN = @ppsn

				IF (@unionMobileNumber LIKE '08%')
					SET @resultMobile = @unionMobileNumber
				ELSE
					IF (@unionHomeNumber LIKE '08%')
						SET @resultMobile = @unionHomeNumber
					ELSE
						SET @resultMobile = NULL

				UPDATE [cabs_production].[cabs_cmo].[Person]
				SET MobileNumber = @resultMobile
				WHERE PPSN = @ppsn

				IF (
						@unionHomeNumber NOT LIKE '08%'
						AND @unionHomeNumber IS NOT NULL
						)
					SET @resultHome = @unionHomeNumber
				ELSE
					IF (
							@unionMobileNumber NOT LIKE '08%'
							AND @unionMobileNumber IS NOT NULL
							)
						SET @resultHome = @unionMobileNumber
					ELSE
						IF (
								@unionMobileNumber LIKE '08%'
								AND @unionHomeNumber LIKE '08%'
								)
							SET @resultHome = @unionHomeNumber
						ELSE
							SET @resultHome = NULL

				UPDATE [cabs_production].[cabs_cmo].[Person]
				SET HomeNumber = @resultHome
				WHERE PPSN = @ppsn

				DECLARE @personId INT

				SELECT @personId = ID
				FROM [cabs_production].[cabs_cmo].[Person]
				WHERE PPSN = @ppsn

				-- INSERT INTO AUDIT TABLE
				PRINT 'Updating Audit table'

				INSERT INTO [cabs_production].[cabs_cmo].[PersonAudit] (
					[FirstName]
					,[LastName]
					,[AddressLine1]
					,[AddressLine2]
					,[AddressLine3]
					,[Town]
					,[CountyID]
					,[CountryID]
					,[PPSN]
					,[DataOfBirth]
					,[Email]
					,[HomeNumber]
					,[MobileNumber]
					,[PostCode]
					,[IrishLanguageAddress]
					,[PersonID]
					,[ModifiedBy]
					,[ModifiedDate]
					,[AuditTypeId]
					)
				VALUES (
					@unionPersonFirstName
					,@unionPersonLastName
					,@unionAddressLine1
					,@unionAddressLine2
					,@unionAddressLine3
					,@unionTown
					,@unionCountyID
					,@unionCountryID
					,@unionPpsn
					,@unionDateOfBirth
					,@unionEmail
					,@resultHome
					,@resultMobile
					,@unionPostCode
					,@unionIrishLanguageAddress
					,@personId
					,@unionModifiedBy
					,getdate() --@unionModified
					,CASE @unionSource
						WHEN 'live'
							THEN 28
						WHEN 'production'
							THEN 27
						ELSE 29
						END
					)
			END

			COMMIT TRANSACTION
		END TRY

		BEGIN CATCH
			--PRINT 'Exception: ' + ERROR_MESSAGE();
			IF @@TRANCOUNT > 0
				ROLLBACK TRANSACTION
		END CATCH

		FETCH NEXT
		FROM db_cursor
		INTO @ppsn
			,@modified;
	END;--while

	CLOSE db_cursor;

	DEALLOCATE db_cursor;

	DROP TABLE #Temp
END

GO


