--Check for Duplicate column and takes the unique value
With Check_for_duplicate as
(
SELECT
    *,
    ROW_NUMBER() OVER (PARTITION BY loan_amnt, term, int_rate, installment, grade, sub_grade,
    emp_title, emp_length, home_ownership, annual_inc,
    verification_status, issue_d, loan_status, purpose, title,
    dti, earliest_cr_line, open_acc, pub_rec, revol_bal,
    revol_util, total_acc, initial_list_status, application_type,
    mort_acc, pub_rec_bankruptcies order by (select null)) as RN
FROM dbo.loan_data
)

SELECT * into Loan_Cleaned_record FROM Check_for_duplicate
WHERE RN = 1
