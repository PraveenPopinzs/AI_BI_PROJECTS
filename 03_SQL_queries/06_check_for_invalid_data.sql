SELECT

    SUM(CASE WHEN TRY_CONVERT(DECIMAL(18,2), loan_amnt) <= 0
        THEN 1 ELSE 0 END) AS Invalid_Loan_Amount,

    SUM(CASE WHEN TRY_CONVERT(DECIMAL(18,2), annual_inc) <= 0
        THEN 1 ELSE 0 END) AS Invalid_Annual_Income,

    SUM(CASE WHEN TRY_CONVERT(DECIMAL(8,2), int_rate) <= 0
               OR TRY_CONVERT(DECIMAL(8,2), int_rate) > 100
        THEN 1 ELSE 0 END) AS Invalid_Interest_Rate,

    SUM(CASE WHEN TRY_CONVERT(DECIMAL(8,2), dti) < 0
        THEN 1 ELSE 0 END) AS Invalid_DTI,

    SUM(CASE WHEN TRY_CONVERT(DECIMAL(8,2), open_acc) < 0
        THEN 1 ELSE 0 END) AS Invalid_Open_Account,

    SUM(CASE WHEN TRY_CONVERT(DECIMAL(8,2), total_acc) < 0
        THEN 1 ELSE 0 END) AS Invalid_Total_Account

FROM dbo.loan_data



