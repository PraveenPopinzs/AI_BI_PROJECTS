/*
Scenario 09 – Customer Income vs Loan Amount Analysis
*/

WITH Income_Groups AS
(
    SELECT
        CASE
            WHEN annual_inc < 30000 THEN 'Low Income'
            WHEN annual_inc < 60000 THEN 'Medium Income'
            WHEN annual_inc < 100000 THEN 'High Income'
            ELSE 'Very High Income'
        END AS Income_Group,

        annual_inc,
        loan_amnt,
        loan_status

    FROM dbo.loan_data
    WHERE annual_inc > 0
)

SELECT
    Income_Group,
    COUNT(*) AS Total_Loans,
    AVG(annual_inc) AS Average_Annual_Income,
    AVG(loan_amnt) AS Average_Loan_Amount,

    SUM(CASE
        WHEN loan_status = 'Charged Off' THEN 1
        ELSE 0
    END) AS Charged_Off_Loans,

    SUM(CASE
        WHEN loan_status = 'Charged Off' THEN 1
        ELSE 0
    END) * 100.0 / NULLIF(COUNT(*), 0)
        AS Charge_Off_Percentage

FROM Income_Groups
GROUP BY Income_Group
