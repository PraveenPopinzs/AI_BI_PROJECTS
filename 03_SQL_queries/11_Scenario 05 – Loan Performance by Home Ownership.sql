/*
Scenario 05 – Loan Performance by Home Ownership
*/

SELECT
    home_ownership,
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
    END) * 100.0 / NULLIF(COUNT(*), 0) AS Charge_Off_Percentage

FROM dbo.loan_data
GROUP BY home_ownership
ORDER BY Charge_Off_Percentage DESC