ALTER proc [dl].[SPLicenceHolderMaster] AS

 select

 ROW_NUMBER() OVER (PARTITION BY tc.PersonId order by tc.TaxClearanceCheckDate desc) 'RankIdTCCheckDate',
 ROW_NUMBER() OVER (PARTITION BY tc.PersonId, rn.RevenueNotificationTypeId order by rn.RevenueNotificationSendDate desc) 'RankIdNotificationType',
 tc.TaxClearanceCheckId,
 tc.PersonId,
 tc.TaxClearanceCheckDate,
 tc.TaxClearanceName,
 tc.TaxClearanceNumber,
 tc.TaxClearanceStatusId,
 rn.RevenueNotificationSendDate,
 rn.RevenueNotificationTypeId,
 tcs.TaxClearanceStatus
 into #TaxClearance
 from person.TaxClearanceCheck tc with (nolock)
 left join person.RevenueNotification rn with (nolock) on rn.TaxClearanceCheckId=tc.TaxClearanceCheckId
 left join person.TaxClearanceStatus tcs with (nolock) on tc.TaxClearanceStatusId = tcs.TaxClearanceStatusId

SELECT distinct lhm.[LicenceMasterId] as [LicenceHolderId]
 ,p.[CCSN] as [Ccsn]
 ,p.[PPSN] as [Ppsn]
 ,CONCAT(i.[FirstName], ' ', i.[LastName]) as [HolderName]
 ,NULL as [TitleID]
 ,i.[FirstName]
 ,i.[LastName]
 ,i.[DateOfBirth]
 ,c.[CompanyNumber]
 ,c.[CompanyName]
 ,i.[TradingAs]
 ,a.[AddressLine1]
 ,a.[AddressLine2]
 ,a.[AddressLine3]
 ,a.[Town]
 ,ct.CountyId as [CountyID]
 ,lm.GardaAreaId as [GardaDivisionID]
 ,a.[PostCode]
 ,(SELECT TOP 1 ltrim(rtrim(phone.PhoneNumber))
 FROM person.Phone phone with (nolock)
 where phone.PersonId=p.PersonId and phone.PhoneTypeId = 1
 order by phone.PhoneId) as [PhoneNo1]
 ,NULL as [ContactNumberFax]
 ,(SELECT TOP 1 ltrim(rtrim(phone.PhoneNumber))
 FROM person.Phone phone with (nolock)
 where phone.PersonId=p.PersonId and phone.PhoneTypeId = 2
 order by phone.PhoneId) as [PhoneNo2]
 ,e.[Email]
 ,tmpTC.[TaxClearanceNumber]
 ,NULL as [TaxClearanceExpiryDate]
 ,NULL as [_6DigitCode]
 ,(CASE
 WHEN p.PersonStatusId = 1 THEN 0
 ELSE 1
 END) as [DeceasedYn]
 ,lm.[LicenceNumber] as [licencenumber]
 ,NULL as [Comments]
 ,p.[CreatedBy]
 ,p.[CreatedDate]
 ,p.[ModifiedBy]
 ,p.[ModifiedDate]
 ,tmpTC.[TaxClearanceStatus]
 ,tmpTC.[TaxClearanceName]
 ,tmpTC.[TaxClearanceCheckDate] as [TaxClearanceLastCheckDate]
 ,NULL as [TaxHead]
 ,tmpTC.[RevenueNotificationSendDate] as [TaxClearanceLastNotificationDate]
 , NULL as[NewMobileNumber]
 , NULL as [NewMobileNumberCreatedDate]
 , NULL as[NewMobileNumberVerificationCode]
 , NULL as[NewMobileNumberVerified]
 ,(CASE
 WHEN tmpTC.[TaxClearanceStatusId] = 1 THEN 1
 ELSE 0
 END) as [TaxClearanceCertExists]
 ,(CASE
 WHEN tmpTC.[TaxClearanceStatusId] = 1 THEN 1
 WHEN tmpTC.[TaxClearanceStatusId] IN (2,3) THEN 0
 ELSE NULL
 END) as [TaxClearancePreviousCertExistsValue]
 ,(SELECT tc1.RevenueNotificationSendDate from #TaxClearance tc1 where tc1.RankIdNotificationType=1 and tc1.RevenueNotificationTypeId=1 and tc1.PersonId=p.PersonId) as [TaxClearanceLastCertExistDate]
 ,tmpTC.[RevenueNotificationSendDate] as [TaxClearance30DaysReminderSent]
 ,pa.AreaId 'PrimaryAreaId'
 FROM [dl].[LicenceHolderMaster] lhm with (nolock)
 join [person].[Person] p with (nolock) on lhm.PersonId = p.PersonId
 left join [person].[Individual] i with (nolock) on p.PersonId = i.PersonId
 left join [person].[Company] c with (nolock) on p.PersonId = c.PersonId
 left join [person].[Address] a with (nolock) on p.PersonId = a.PersonId
 left join [person].[County] ct with (nolock) on ct.CountyId = a.CountyId
 left join [person].[Email] e with (nolock) on p.PersonId = e.PersonId
 left join [dl].[LicenceMaster] lm with (nolock) on lhm.LicenceMasterId = lm.LicenceMasterId
 left join [dl].[Area] pa with (nolock) on pa.AreaId=lm.PrimaryAreaId
 left join #TaxClearance tmpTC on tmpTC.PersonId=p.PersonId and tmpTC.RankIdTCCheckDate=1

drop table #TaxClearance