/*
Scenario 06 – Loan Issuance Trend by Year and Month
*/

SELECT
    YEAR(issue_d) AS Loan_Year,
    DATENAME(MONTH, issue_d) AS Loan_Month,
    COUNT(*) AS Total_Loans,
    SUM(loan_amnt) AS Total_Loan_Amount
FROM dbo.loan_data
GROUP BY
    YEAR(issue_d),
    MONTH(issue_d),
    DATENAME(MONTH, issue_d)
ORDER BY
    Loan_Year,
    MONTH(issue_d)