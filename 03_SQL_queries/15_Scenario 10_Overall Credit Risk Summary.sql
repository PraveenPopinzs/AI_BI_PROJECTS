/*
Scenario 10 – Overall Credit Risk Summary
*/

SELECT
    COUNT(*) AS Total_Loans,

    SUM(loan_amnt) AS Total_Loan_Amount,

    AVG(loan_amnt) AS Average_Loan_Amount,

    SUM(CASE
        WHEN loan_status = 'Fully Paid'
        THEN 1 ELSE 0
    END) AS Fully_Paid_Loans,

    SUM(CASE
        WHEN loan_status = 'Charged Off'
        THEN 1 ELSE 0
    END) AS Charged_Off_Loans,

    SUM(CASE
        WHEN loan_status = 'Charged Off'
        THEN 1 ELSE 0
    END) * 100.0 / NULLIF(COUNT(*), 0)
        AS Overall_Charge_Off_Percentage,

    AVG(int_rate) AS Average_Interest_Rate,

    AVG(dti) AS Average_DTI

FROM dbo.loan_data