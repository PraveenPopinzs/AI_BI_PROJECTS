--Scenario 01 – Loan Performance Analysis

/*
Total number of loans.
Fully Paid loan count.
Charged Off loan count.
Percentage of Fully Paid loans.
Percentage of Charged Off loans.
*/

SELECT
    *,
    Fully_Paid_loan_count * 100.0 /
        NULLIF(Total_number_of_loans, 0) AS Percentage_of_Fully_Paid_loans,

    Charged_Off_loan_count * 100.0 /
        NULLIF(Total_number_of_loans, 0) AS Percentage_of_Charged_Off_loans
FROM
(
    SELECT
        COUNT(*) AS Total_number_of_loans,
        SUM(CASE WHEN loan_status = 'Fully Paid' THEN 1 ELSE 0 END) AS Fully_Paid_loan_count,
        SUM(CASE WHEN loan_status = 'Charged Off' THEN 1 ELSE 0 END) AS Charged_Off_loan_count
    FROM dbo.Loan_data
) t