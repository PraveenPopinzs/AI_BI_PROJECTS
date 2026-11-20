/*
Scenario 07 – Loan Amount and Charge-off Analysis by Grade
*/

SELECT
    grade AS Loan_Grade,
    COUNT(*) AS Total_Loans,
    SUM(loan_amnt) AS Total_Loan_Amount,

    AVG(loan_amnt) AS Average_Loan_Amount,

    SUM(CASE
        WHEN loan_status = 'Charged Off'
        THEN loan_amnt ELSE 0
    END) AS Charged_Off_Loan_Amount,

    SUM(CASE
        WHEN loan_status = 'Charged Off'
        THEN 1 ELSE 0
    END) AS Charged_Off_Loan_Count,

    SUM(CASE
        WHEN loan_status = 'Charged Off'
        THEN 1 ELSE 0
    END) * 100.0 / NULLIF(COUNT(*), 0)
        AS Charge_Off_Percentage

FROM dbo.loan_data
GROUP BY grade
ORDER BY grade