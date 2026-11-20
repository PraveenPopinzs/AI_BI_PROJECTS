/*
Scenario 04 – Loan Performance by Employment Length
*/

SELECT
    emp_length,
    COUNT(*) AS Total_Loans,

    SUM(CASE
        WHEN loan_status = 'Fully Paid' THEN 1
        ELSE 0
    END) AS Fully_Paid_Loans,

    SUM(CASE
        WHEN loan_status = 'Charged Off' THEN 1
        ELSE 0
    END) AS Charged_Off_Loans,

    SUM(CASE
        WHEN loan_status = 'Charged Off' THEN 1
        ELSE 0
    END) * 100.0 /
    NULLIF(COUNT(*), 0) AS Charge_Off_Percentage

FROM dbo.loan_data
GROUP BY emp_length
ORDER BY Charge_Off_Percentage DESC