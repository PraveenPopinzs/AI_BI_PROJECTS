--Data cleaned and moved to new table


SELECT
    loan_amnt,
    TRIM(term) AS term,
    int_rate,
    installment,
    grade,
    sub_grade,
    TRIM(emp_title) AS emp_title,
    TRIM(emp_length) AS emp_length,
    home_ownership,
    annual_inc,
    verification_status,
    issue_d,
    loan_status,
    purpose,
    TRIM(title) AS title,
    dti,
    earliest_cr_line,
    TRY_CONVERT(INT, open_acc) AS open_acc,
    pub_rec,
    revol_bal,
    TRY_CONVERT(DECIMAL(8,2), revol_util) AS revol_util,
    TRY_CONVERT(INT, total_acc) AS total_acc,
    initial_list_status,
    application_type,
    mort_acc,
    pub_rec_bankruptcies
INTO dbo.loan_data_cleaned
FROM dbo.loan_data

SELECT * FROM loan_data_cleaned