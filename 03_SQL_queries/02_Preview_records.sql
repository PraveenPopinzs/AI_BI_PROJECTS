USE BankLoanAnalysis
GO

-- 1. Total record count
SELECT COUNT(*) AS Total_Records
FROM dbo.loan_data

-- 2. Preview records
SELECT TOP 10 *
FROM dbo.loan_data

