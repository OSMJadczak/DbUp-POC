SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [person].[proc_insert_to_ops] (
	@SourceSystem as varchar(3), 
	@Id as int, 
	@PersonType as varchar(20),
	@PersonStatus as varchar(20),
	@Ppsn as varchar(20), 
	@FirstName as nvarchar(50), 
	@LastName as nvarchar(50), 
	@CompanyName as nvarchar(100), 
	@CompanyNumber as int, 
	@TradingAs as nvarchar(100), 
	@DateOfBirth as date, 
	@MobilePhone as varchar(50), 
	@OtherPhone as varchar(50), 
	@Email as varchar(50), 
	@AddressLine1 as nvarchar(100), 
	@AddressLine2 as nvarchar(100), 
	@AddressLine3 as nvarchar(100), 
	@Irish as bit,
	@EirCode as varchar(7), 
	@PrefContactMethod as varchar(20), 
	@Town as nvarchar(50), 
	@PostCode as varchar(12), 
	@CountyName as nvarchar(20), 
	@CountryName as varchar(20), 
	@CreatedBy as nvarchar(256), 
	@CreatedOn as datetime, 
	@ModifiedBy as nvarchar(256), 
	@ModifiedOn as datetime, 
	@ETLId as int
	)
as
BEGIN

declare @ErrorNumber as int = NULL
declare @ErrorMessage as nvarchar(4000) = NULL

declare @PersonTypeId int = NULL
declare @PersonStatusId int = NULL
declare @ContactMethodId int = NULL
declare @CountryId int = NULL
declare @CountyId int = NULL
declare @PersonId int = NULL
declare @AddressId int = NULL
declare @EmailId int = NULL
declare @PhoneTypeId int = NULL
declare @Phone varchar(50) = NULL
declare @PhoneId int = NULL

declare @ccsn varchar(10) 
declare @ShortName as nvarchar(2)



set @PersonType =		ltrim(rtrim(@PersonType))
set @PersonStatus =		ltrim(rtrim(@PersonStatus))
set @Ppsn =				ltrim(rtrim(@Ppsn))
set @FirstName =		ltrim(rtrim(@FirstName))
set @LastName =			ltrim(rtrim(@LastName))
set @CompanyName =		ltrim(rtrim(@CompanyName))
set @TradingAs =		ltrim(rtrim(@TradingAs))
set @MobilePhone =		ltrim(rtrim(@MobilePhone))
set @OtherPhone =		ltrim(rtrim(@OtherPhone))
set @Email =			ltrim(rtrim(@Email))
set @AddressLine1 =		ltrim(rtrim(@AddressLine1))
set @AddressLine2 =		ltrim(rtrim(@AddressLine2))
set @AddressLine3 =		ltrim(rtrim(@AddressLine3))
set @EirCode =			ltrim(rtrim(@EirCode))
set @PrefContactMethod= ltrim(rtrim(@PrefContactMethod))
set @Town =				ltrim(rtrim(@Town))
set @PostCode =			ltrim(rtrim(@PostCode))
set @CountyName =		ltrim(rtrim(@CountyName))
set @CountryName =		ltrim(rtrim(@CountryName))
set @CreatedBy =		ltrim(rtrim(@CreatedBy))
set @ModifiedBy =		ltrim(rtrim(@ModifiedBy))



declare @tally as table (N int) 
insert into @tally select top (100) row_number() over (order by @@spid) from sys.all_columns

If @CountyName is null or @CountyName = ''
	set @CountyName = 'N/A'

BEGIN TRY
		BEGIN TRANSACTION;

		--PERSON TYPE
			IF not exists (select * from person.PersonType with (nolock) where PersonType=@PersonType)
				BEGIN
					set @ErrorNumber = 13001
					set @ErrorMessage = ('Not found ' + isnull(@PersonType, 'NULL') + ' in table person.PersonType for ' + isnull(@SourceSystem, 'NULL') + ' id: ' + isnull(convert(nvarchar(10), @id), 'NULL') + ' PPSN: ' + isnull(@PPSN, 'NULL'))
					goto errorstatement
				END
			ELSE
				BEGIN
					select @PersonTypeId=PersonTypeId from person.PersonType with (nolock) where PersonType=@PersonType
				END

		--PERSON STATUS
			IF not exists (select * from person.PersonStatus with (nolock) where PersonStatus=@PersonStatus)
				BEGIN
					set @ErrorNumber = 13002
					set @ErrorMessage = ('Not found ' + isnull(@PersonStatus, 'NULL') + ' in table person.PersonStatus for ' + isnull(@SourceSystem, 'NULL') + ' id: ' + isnull(convert(nvarchar(10), @id), 'NULL') + ' PPSN: ' + isnull(@PPSN, 'NULL'))
					goto errorstatement
				END
			ELSE
				BEGIN
					select @PersonStatusId=PersonStatusId from person.PersonStatus with (nolock) where PersonStatus=@PersonStatus
				END
		--PrefContactMethod
		if @PrefContactMethod is not null
		begin
			IF not exists (select * from person.ContactMethod with (nolock) where ContactMethod=@PrefContactMethod)
				BEGIN
					set @ErrorNumber = 13004
					set @ErrorMessage = ('Not found ' + isnull(@PrefContactMethod, 'NULL') + ' in table person.ContactMethod for ' + isnull(@SourceSystem, 'NULL') + ' id: ' + isnull(convert(nvarchar(10), @id), 'NULL') + ' PPSN: ' + isnull(@PPSN, 'NULL'))
					goto errorstatement
				END
			ELSE
				BEGIN
					select @ContactMethodId=ContactMethodId from person.ContactMethod with (nolock) where ContactMethod=@PrefContactMethod
				END
		end
		else
		begin
			set @ContactMethodId = NULL
		end

		--CountryName, CountyName
			BEGIN
				select @CountryId=CountryId from person.Country with (nolock) where CountryName=@CountryName

				IF not exists (select * from person.County with (nolock) where CountryId=@CountryId and (case when len(CountyName) = 0 then 'N/A' else CountyName end=@CountyName or CountyIrishName=@CountyName))
					BEGIN
						set @ErrorNumber = 13006
						set @ErrorMessage = ('Not found ' + isnull(@CountyName, 'NULL') + ' in table person.County for ' + isnull(@SourceSystem, 'NULL') + ' id: ' + isnull(convert(nvarchar(10), @id), 'NULL') + ' PPSN: ' + isnull(@PPSN, 'NULL'))
						goto errorstatement
					END
				ELSE
					BEGIN
						select @CountyId=CountyId from person.County with (nolock) where CountryId=@CountryId and (case when len(CountyName) = 0 then 'N/A' else CountyName end=@CountyName or CountyIrishName=@CountyName)
					END

			END
		if @MobilePhone like '8%' and len(@MobilePhone)=9
			set @MobilePhone = '0'+@MobilePhone 

		IF @SourceSystem not in ('OPV', 'DMR')
			BEGIN
				IF not exists (select * from person.Person with (nolock) where PPSN=@PPSN)
------------------ADD NEW PERSON
					BEGIN
						print 'Insert NEW PERSON with PPSN=' + @PPSN

						set @ccsn = person.udf_GenerateCCSN (@FirstName, @LastName,@CompanyName)
						
						INSERT INTO person.Person
							select @ccsn, @Ppsn, @PersonTypeId, @PersonStatusId, @ContactMethodId, 'SP: person.proc_insert_to_ops: ' + rtrim(convert(varchar(10), @ETLId)), getdate(), NULL, NULL

						set @PersonId = (select scope_identity())


						--DATASOURCE
						INSERT INTO person.DataSource
							select @PersonId, @SourceSystem, @Id, @ETLId, @CreatedBy, @CreatedOn, @ModifiedBy, @ModifiedOn

						--COMPANY/INDIVIDUAL
						IF @PersonType = 'Company'
							BEGIN
								INSERT INTO person.Company
									select @PersonId, @CompanyName, @CompanyNumber, @TradingAs, 'SP: person.proc_insert_to_ops: ' + rtrim(convert(varchar(10), @ETLId)), getdate(), NULL, NULL
							END
						ELSE IF @PersonType = 'Individual'
							BEGIN
								INSERT INTO person.Individual
									select @PersonId, @FirstName, @LastName, @DateOfBirth, @TradingAs, 'SP: person.proc_insert_to_ops: ' + rtrim(convert(varchar(10), @ETLId)), getdate(), NULL, NULL
							END

						--GEOGRAPHICAL
							--ADDRESS
							INSERT INTO person.Address
								select @PersonId, @AddressLine1, @AddressLine2, @AddressLine3, @Town, @PostCode, @CountyId, @EirCode, @Irish, 'SP: person.proc_insert_to_ops: ' + rtrim(convert(varchar(10), @ETLId)), getdate(), NULL, NULL

							--EMAIL
							if @Email is not null
							BEGIN
								INSERT INTO person.Email
									select @PersonId, @Email, 'SP: person.proc_insert_to_ops: ' + rtrim(convert(varchar(10), @ETLId)), getdate(), NULL, NULL
							END

							--Phone
							select @PhoneTypeId=PhoneTypeId from person.PhoneType where PhoneType = 'Mobile'

							IF (@PhoneTypeId IS NOT NULL)
							BEGIN
								IF (@MobilePhone IS NOT NULL)
								BEGIN
									declare insert_phone cursor for
										select * from STRING_SPLIT(@MobilePhone, ',')
									OPEN insert_phone;
									FETCH NEXT FROM insert_phone INTO @Phone;
									WHILE @@FETCH_STATUS=0
									BEGIN
										INSERT INTO person.Phone
											select @PersonId, @Phone, @PhoneTypeId, 'SP: person.proc_insert_to_ops: ' + rtrim(convert(varchar(10), @ETLId)), getdate(), NULL, NULL

									FETCH NEXT FROM insert_phone INTO @Phone;
									END
									CLOSE insert_phone   
									DEALLOCATE insert_phone
								END
							END
							ELSE
							BEGIN
								set @ErrorNumber = 13005
								set @ErrorMessage = ('Not found Mobile Phone Type in table person.PhoneType for ' + isnull(@SourceSystem, 'NULL') + ' id: ' + isnull(convert(nvarchar(10), @id), 'NULL') + ' PPSN: ' + isnull(@PPSN, 'NULL'))
								goto errorstatement
							END

							select @PhoneTypeId=PhoneTypeId from person.PhoneType where PhoneType = 'Home'

							IF (@PhoneTypeId IS NOT NULL)
							BEGIN
								IF (@OtherPhone IS NOT NULL)
									BEGIN
										declare insert_phone cursor for
											select * from STRING_SPLIT(@OtherPhone, ',')
										OPEN insert_phone;
										FETCH NEXT FROM insert_phone INTO @Phone;
										WHILE @@FETCH_STATUS=0
											BEGIN
												INSERT INTO person.Phone
													select @PersonId, @Phone, @PhoneTypeId, 'SP: person.proc_insert_to_ops: ' + rtrim(convert(varchar(10), @ETLId)), getdate(), NULL, NULL

											FETCH NEXT FROM insert_phone INTO @Phone;
											END
										CLOSE insert_phone   
										DEALLOCATE insert_phone
									END
							END
							ELSE
							BEGIN
								set @ErrorNumber = 13007
								set @ErrorMessage = ('Not found Home Phone Type in table person.PhoneType for ' + isnull(@SourceSystem, 'NULL') + ' id: ' + isnull(convert(nvarchar(10), @id), 'NULL') + ' PPSN: ' + isnull(@PPSN, 'NULL'))
								goto errorstatement
							END
				
					END
				ELSE IF not exists (select * from person.Person p with (nolock) inner join person.DataSource ds with (nolock) on p.PersonId=ds.PersonId where PPSN=@PPSN and ds.SourceSystemName=@SourceSystem and ds.SourceSystemId=@id)
------------------ADD INFO ABOUT DATA SOURCE
					BEGIN
						select @PersonId=PersonId from person.Person with (nolock) where PPSN=@PPSN
						INSERT INTO person.DataSource
							select @PersonId, @SourceSystem, @Id, @ETLId, @CreatedBy, @CreatedOn, @ModifiedBy, @ModifiedOn
					END
				--ELSE
				--	BEGIN
				--		select 'Person was copied to OPV'
				--	END
				--END
			END
		ELSE
------------UPDATE PERSON
			BEGIN
				--Check if should update
				declare @md datetime
				select @PersonId=PersonId, @md=isnull(ModifiedDate, CreatedDate) from Person.Person where PPSN=@PPSN

				print 'Update person - check the dates if we need make updates. ModifiedDate from Variable:' + convert(varchar(20), isnull(@ModifiedOn, @CreatedOn),120) + ' ModifiedDate from Person' + convert(varchar(20), @md,120)
				
				if exists (select * from Person.Person where PersonId=@PersonId and isnull(@ModifiedOn, @CreatedOn)>isnull(ModifiedDate, CreatedDate))
				BEGIN
					print 'Updating Person: PPSN=' + @PPSN
					set @ModifiedBy='SP: person.proc_insert_to_ops: ' + rtrim(convert(varchar(10), @ETLId)) + ' _' + @ModifiedBy

					--check if persontype was changed
					declare @ChangedPersonType bit = NULL
					if @PersonTypeId!=(select PersonTypeId from person.person where PersonId=@PersonId)
					begin
						set @ChangedPersonType=1
						print 'Changed PersonType'
					end	
					
					UPDATE person.person set
						PersonTypeId=@PersonTypeId,
						PersonStatusId=@PersonStatusId,
						ContactMethodId=@ContactMethodId,
						ModifiedBy=@ModifiedBy,
						ModifiedDate=@ModifiedOn
					where PersonId=@PersonId

					IF @ChangedPersonType=1
						begin
							print 'Changed person type'
							delete from person.Company where PersonId=@PersonId
							delete from person.Individual where PersonId=@PersonId

							IF @PersonType = 'Company'
							BEGIN
								INSERT INTO person.Company
									select @PersonId, @CompanyName, @CompanyNumber, @TradingAs, 'SP: person.proc_insert_to_ops: ' + rtrim(convert(varchar(10), @ETLId)), getdate(), NULL, NULL
							END
							ELSE IF @PersonType = 'Individual'
								BEGIN
									INSERT INTO person.Individual
										select @PersonId, @FirstName, @LastName, @DateOfBirth, @TradingAs, 'SP: person.proc_insert_to_ops: ' + rtrim(convert(varchar(10), @ETLId)), getdate(), NULL, NULL
								END
						end
					ELSE
						IF @PersonType = 'Company'
							BEGIN
								UPDATE person.Company set
									CompanyName=@CompanyName, 
									CompanyNumber=@CompanyNumber, 
									TradingAs=@TradingAs, 
									ModifiedBy=@ModifiedBy,
									ModifiedDate=@ModifiedOn
								where PersonId=@PersonId 
								and (
									CompanyName!=@CompanyName or
									CompanyNumber!=@CompanyNumber or
									TradingAs!=@TradingAs
									)

							END
						ELSE IF @PersonType = 'Individual'
							BEGIN
								UPDATE person.Individual set
									FirstName=@FirstName, 
									LastName=@LastName, 
									DateOfBirth=@DateOfBirth, 
									TradingAs=@TradingAs, 
									ModifiedBy=@ModifiedBy,
									ModifiedDate=@ModifiedOn
								where PersonId=@PersonId
									and (
									FirstName!=@FirstName or 
									LastName!=@LastName or
									DateOfBirth!=@DateOfBirth or
									TradingAs!=@TradingAs
									)
							END

						--GEOGRAPHICAL
							--ADDRESS
							UPDATE person.Address set
								AddressLine1=@AddressLine1, 
								AddressLine2=@AddressLine2, 
								AddressLine3=@AddressLine3, 
								Town=@Town, 
								PostCode=@PostCode, 
								CountyId=@CountyId, 
								EirCode=@EirCode, 
								Irish=@Irish, 
								ModifiedBy=@ModifiedBy,
								ModifiedDate=@ModifiedOn
							where PersonId=@PersonId
								and (
								AddressLine1!=@AddressLine1 or
								AddressLine2!=@AddressLine2 or
								AddressLine3!=@AddressLine3 or
								Town!=@Town or
								PostCode!=@PostCode or
								CountyId!=@CountyId or
								EirCode!=@EirCode or
								Irish!=@Irish
								)

							--EMAIL
							if @Email is not null
								update person.Email set
									Email=@Email, 
									ModifiedBy=@ModifiedBy,
									ModifiedDate=@ModifiedOn
								where PersonId=@PersonId 
									and Email!=@Email
							else
								delete from person.Email where PersonId=@PersonId

							--Phone
							select @PhoneTypeId=PhoneTypeId from person.PhoneType where PhoneType = 'Mobile'

							IF (@PhoneTypeId IS NOT NULL)
							BEGIN
								print 'Updating Mobile Phone Number'
								delete from person.Phone where PersonId=@PersonId and PhoneTypeId=@PhoneTypeId
								IF (@MobilePhone IS NOT NULL)
								BEGIN
									declare insert_phone cursor for
										select * from STRING_SPLIT(@MobilePhone, ',')
									OPEN insert_phone;
									FETCH NEXT FROM insert_phone INTO @Phone;
									WHILE @@FETCH_STATUS=0
									BEGIN
										INSERT INTO person.Phone
											select @PersonId, @Phone, @PhoneTypeId, 'SP: person.proc_insert_to_ops: ' + rtrim(convert(varchar(10), @ETLId)), getdate(), NULL, NULL

										FETCH NEXT FROM insert_phone INTO @Phone;
									END
									CLOSE insert_phone   
									DEALLOCATE insert_phone

								END
							END
							ELSE
							BEGIN
								set @ErrorNumber = 13015
								set @ErrorMessage = ('Not found Mobile in table person.PhoneType for ' + isnull(@SourceSystem, 'NULL') + ' id: ' + isnull(convert(nvarchar(10), @id), 'NULL') + ' PPSN: ' + isnull(@PPSN, 'NULL'))
								goto errorstatement
							END

							select @PhoneTypeId=PhoneTypeId from person.PhoneType where PhoneType = 'Home'

							IF (@PhoneTypeId IS NOT NULL)
							BEGIN
								print 'Updating Home Phone Number'
								delete from person.Phone where PersonId=@PersonId and PhoneTypeId=@PhoneTypeId
								IF (@OtherPhone IS NOT NULL)
								BEGIN
									declare insert_phone cursor for
										select * from STRING_SPLIT(@OtherPhone, ',')
									OPEN insert_phone;
									FETCH NEXT FROM insert_phone INTO @Phone;
									WHILE @@FETCH_STATUS=0
									BEGIN
										INSERT INTO person.Phone
											select @PersonId, @Phone, @PhoneTypeId, 'SP: person.proc_insert_to_ops: ' + rtrim(convert(varchar(10), @ETLId)), getdate(), NULL, NULL

										FETCH NEXT FROM insert_phone INTO @Phone;
									END
									CLOSE insert_phone   
									DEALLOCATE insert_phone
								END
							END
							ELSE
							BEGIN
								set @ErrorNumber = 13007
								set @ErrorMessage = ('Not found Home Phone Type in table person.PhoneType for ' + isnull(@SourceSystem, 'NULL') + ' id: ' + isnull(convert(nvarchar(10), @id), 'NULL') + ' PPSN: ' + isnull(@PPSN, 'NULL'))
								goto errorstatement
							END
				END
			END



		--set @ErrorNumber = 14000
	--select @ErrorNumber
	errorstatement:
		if @ErrorNumber is null
			COMMIT TRANSACTION;
		else
			begin
				ROLLBACK TRANSACTION;
				insert into cabs.cleansing.ErrorLog
				select 
					@ETLId, getdate(), 'proc_insert_to_ops', @ErrorNumber, @ErrorMessage, @SourceSystem, @id
			end
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			BEGIN
				ROLLBACK TRANSACTION;
				
				insert into cabs.cleansing.ErrorLog
				select 
					@ETLId 'ETLId',  
					getdate() 'Date', 
					ERROR_PROCEDURE() 'ERROR_PROCEDURE', 
					case when @ErrorNumber is null then  ERROR_NUMBER() else @ErrorNumber end 'ERROR_NUMBER', 
					case when @ErrorMessage is null then ERROR_MESSAGE() else @ErrorMessage end 'ERROR_MESSAGE',
					@SourceSystem, 
					@id
				--into cleansing.ErrorLog
			END
	END CATCH;

END
GO
