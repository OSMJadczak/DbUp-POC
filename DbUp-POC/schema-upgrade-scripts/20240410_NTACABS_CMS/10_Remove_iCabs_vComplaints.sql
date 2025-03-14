IF OBJECT_ID('[cabs_enf].[vComplaints]', 'V') IS NOT NULL
    print '[cabs_enf].[vComplaints] view exist'
    DROP VIEW [cabs_enf].[vComplaints]
GO