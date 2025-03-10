 
# CABS SQL SERVER SCRIPTS

## What is this repository for? ###

This folder contains scripts and stored procedures created during ongoing CABS systems development such as:
 * Hotfixes and support service patches
 * Maintenance Releases
 * Development of new modules
 
## Naming Conventions ###

* ### Hotfixes / RCU's

    1. Each hot fix sripts should be grouped under newly created folder:
    ```
    YYYYMMDD_<Jira_Ref_No_or_General_Name>_<Short_Description_or_ProcedureName>
    ```

    2. Each folder should contain one or more scripts: ```
    YYYYMMDD_<Jira_Ref_No_or_General_Name>_<Short_Description_or_ProcedureName>```
   
    **Samples:**
    

    *Folder:*

            20180108_NTACABS-1170_RCU74_SMS_Service_Report

    *Scripts:*

            20180108_NTACABS-1170_[dbo].[LicenceMasterVLAudit_SelectByRegistrationNumber].sql
            20180814_NTACABS-14_RCU74_report_to_monitor_changes_to_SMS_Service_Number_Count_Report_Procedure.sql
            
            
    
* ### Maintenance Releases

    1. Each hot fix sripts should be grouped under newly created folder:
    ```
    YYYYMMDD_<PROJ_CODE_or_General_PROJ_Name>
    ```

    2. Each folder should contain one or more scripts:```
    YYYYMMDD_<Jira_Ref_No_or_General_Name>_<Short_Description_or_ProcedureName>
    ```

    **Samples:**

     *Folder:*

        20180108_NTACABSMR1

     *Scripts:*

        20190326_2_ALTER_PROCEDURE_[dbo].[LicenceNominee_Insert].sql 
        20190326_AddNomineeSiteMap.sql

* ### Development of new modules

    1. Each hot fix sripts should be grouped under newly created folder:
    ```
    YYYYMMDD_<PROJ_CODE_or_General_PROJ_Name>
    ```

    2. Each folder should contain one or more scripts: 
    ```
    YYYYMMDD_<Jira_Ref_No_or_General_Name>_<Short_Description_or_ProcedureName>
    ```

    **Samples:**

     *Folder:*

        20180108_NTACDBMRG

     *Scripts:*

        20180108_NTACABS-1170_[dbo].[LicenceMasterVLAudit_SelectByRegistrationNumber].sql
        20180814_NTACABS-14_RCU74_report_to_monitor_changes_to_SMS_Service_Number_Count_Report_Procedure.sql


## NOTES:

Remember for each database script to contain:

* Database name it is executed against - ie:
    ```
    USE cabs_production
    ```
* For Stored Procedures - Create OR ALTER command:
```
    CREATE OR ALTER PROCEDURE [dbo].[LicenceNominee_Insert]
    AS
    BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    -- <BODY HERE>

    END
```
    
* For scripts modifying schema - GO instruction after schema changing script:
```
    USE cabs_production
    GO

    ALTER TABLE [dbo].[LicenceNominee]
    DROP COLUMN LicenceHolderMasterId

    -- REMEMBER TO PUT GO HERE IF ADDITIONAL SCRIPTS EXECUTED BELOW-->
    GO
```