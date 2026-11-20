/*
Scenario 02 – Loan Grade Risk Analysis
Loan grade.
Total number of loans.
Fully Paid loan count.
Charged Off loan count.
Charge-off percentage.
*/

SELECT
    *,
    charge_off_loan * 100.0 /
        NULLIF(Total_number_of_loans, 0) AS Charge_off_percentage
FROM
(
    SELECT
        grade AS Loan_grade,
        COUNT(*) AS Total_number_of_loans,
        SUM(CASE WHEN loan_status = 'Fully Paid'
            THEN 1 ELSE 0 END) AS fully_paid_loan,
        SUM(CASE WHEN loan_status = 'Charged Off'
            THEN 1 ELSE 0 END) AS charge_off_loan
    FROM dbo.Loan_data
    GROUP BY grade
) t
ORDER BY Loan_grade