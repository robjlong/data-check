USE DataCheck
GO
EXEC data_testing.GenerateTestSetupScript @TestName = 'Customer Open Order Quantities' -- varchar(500)
EXEC data_testing.GenerateTestSetupScript @TestName = 'Total Transactions By Type' -- varchar(500)
