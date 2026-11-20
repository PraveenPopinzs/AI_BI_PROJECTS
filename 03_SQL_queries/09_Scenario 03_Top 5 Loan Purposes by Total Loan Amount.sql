/*
Scenario 03 – Top 5 Loan Purposes by Total Loan Amount
*/

SELECT TOP 5
    Loan_Purpose,
    Loan_count,
    Total_loan_amount,
    Total_loan_amount/ NULLIF(Loan_count, 0) AS Average_Loan_Amount
FROM
(
    SELECT
        purpose AS Loan_Purpose,
        COUNT(*) AS Loan_count,
        SUM(loan_amnt) AS Total_loan_amount
    FROM dbo.Loan_data
    GROUP BY purpose
) t
ORDER BY Total_loan_amount DESC