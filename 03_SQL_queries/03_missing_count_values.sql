SELECT
    loan_status,

    COUNT(*) AS Total_Records,

    SUM(CASE WHEN emp_title IS NULL OR TRIM(emp_title) = '' THEN 1 ELSE 0 END) AS Missing_emp_title,

    SUM(CASE WHEN emp_length IS NULL OR TRIM(emp_length) = '' THEN 1 ELSE 0 END) AS Missing_emp_length,

    SUM(CASE WHEN mort_acc IS NULL THEN 1 ELSE 0 END) AS Missing_mort_acc,

    SUM(CASE WHEN title IS NULL OR TRIM(title) = '' THEN 1 ELSE 0 END) AS Missing_title,

    SUM(CASE WHEN revol_util IS NULL THEN 1 ELSE 0 END) AS Missing_revol_util,

    SUM(CASE WHEN pub_rec_bankruptcies IS NULL THEN 1 ELSE 0 END) AS Missing_pub_rec_bankruptcies

FROM dbo.loan_data
GROUP BY loan_status

