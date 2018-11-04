USE DataCheck
GO

--------------------------------------------------------------------------------------------------
--	Below is a sample script used in the presentation demo.
--
--	Notes:
--	The demo environment is using WorldWideImporters & WorldWideImportersDW.  In addition, we've
--	made a copy of WorldWideImporters (WorldWideImporters_PSE) to reflect a stage environment.
--
--------------------------------------------------------------------------------------------------


/*
										TEST TEMPLATE
	Instructions:
		1. Populate the Test Attributes (Name, Description, and Group)
		2. Define the target server, database, and query for the resultset to be evaluated.
			a. Repeat this section as many times as needed.
		3. Execute the script (This can be run multiple times, and will make changes to queries.)
*/
--------------------------------------------------------------------------------------------------
--	1. 
--	CREATE Test Definition
--------------------------------------------------------------------------------------------------
DECLARE @TestDefinitionId INT;
EXEC data_testing.AddTest @Name = 'Total Transactions By Type' -- Unique Test Name, this should be distinctive
                        , @Description = 'Comparing all transaction amounts, grouped by transaction type.' -- A place holder to define this test.  Make use of this, you'll appreciate it later
                        , @Group = 'Daily Sales Metrics' -- Put this test in a group to have it executed with other tests at the same time
                        , @TestDefinitionId = @TestDefinitionId OUTPUT; -- Used later. No need to adjust this.

--------------------------------------------------------------------------------------------------
--	ASSIGNING QUERY & CONNECTION COMBINATIONS TO THE TEST
--------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------
--	2.
--	Assigns a query and connection to the test defined above.
--	This section will should be repeated for each result set to be evaluated in the test.
--------------------------------------------------------------------------------------------------
EXEC data_testing.AssignNewQuery @TestDefinitionId = @TestDefinitionId -- int
                               , @ServerName = 'localhost'			-- The remote server name
                               , @Database = 'WorldWideImporters'			-- The remote database name
                               , @QueryName = 'WWI - Total Transactions'			-- A unique query name, keep in mind that a single query may be run against multiple systems
							   , @QuerySortOrder = 100	-- OPTIONAL : The order placed on the query/connection combination.  This can be used to show "data flow"
							   , @CommandText = -- OPTIONAL : The SELECT Statement that meets the needs of the test to return results for evaluation
									'
--------------------------------------------------------------------------------------------------
--	We''ve got to UNION both Supplier & Customer Transactions to tie out to the fact table
--------------------------------------------------------------------------------------------------

SELECT   tye.TransactionTypeName [GroupName]
       , SUM(t.TransactionAmount) +1 [Value]
FROM     Sales.CustomerTransactions t
         JOIN [Application].TransactionTypes tye ON tye.TransactionTypeID = t.TransactionTypeID
GROUP BY tye.TransactionTypeName
UNION
SELECT   tye.TransactionTypeName [GroupName]
       , SUM(t.TransactionAmount) [Value]
FROM     Purchasing.SupplierTransactions t
         JOIN [Application].TransactionTypes tye ON tye.TransactionTypeID = t.TransactionTypeID
GROUP BY tye.TransactionTypeName;

';
	

--------------------------------------------------------------------------------------------------
--	2.
--	Assigns a query and connection to the test defined above.
--	This section will should be repeated for each result set to be evaluated in the test.
--------------------------------------------------------------------------------------------------
EXEC data_testing.AssignNewQuery @TestDefinitionId = @TestDefinitionId -- int
                               , @ServerName = 'localhost'			-- The remote server name
                               , @Database = 'WorldWideImporters_PSE'			-- The remote database name
                               , @QueryName = 'WWI - Total Transactions'			-- A unique query name, keep in mind that a single query may be run against multiple systems
							   , @QuerySortOrder = 200	-- OPTIONAL : The order placed on the query/connection combination.  This can be used to show "data flow"
							   	

--------------------------------------------------------------------------------------------------
--	2.
--	Assigns a query and connection to the test defined above.
--	This section will should be repeated for each result set to be evaluated in the test.
--------------------------------------------------------------------------------------------------
EXEC data_testing.AssignNewQuery @TestDefinitionId = @TestDefinitionId -- int
                               , @ServerName = 'localhost'			-- The remote server name
                               , @Database = 'WorldWideImportersDW'			-- The remote database name
                               , @QueryName = 'WWI_DW - Total Transactions'			-- A unique query name, keep in mind that a single query may be run against multiple systems
							   , @QuerySortOrder = 300	-- OPTIONAL : The order placed on the query/connection combination.  This can be used to show "data flow"
							   , @CommandText = -- OPTIONAL : The SELECT Statement that meets the needs of the test to return results for evaluation
									'
SELECT   typ.[Transaction Type] [GroupName]
       , SUM(t.[Total Including Tax]) [Value]
FROM     Fact.[Transaction] t
         JOIN Dimension.[Transaction Type] typ ON typ.[Transaction Type Key] = t.[Transaction Type Key]
GROUP BY typ.[Transaction Type];
';
	

--------------------------------------------------------------------------------------------------
--	No changes needed.
--	Show the overall design of the Test
--------------------------------------------------------------------------------------------------
SELECT  *
FROM    data_testing.TestDesign
WHERE   TestDefinitionId = @TestDefinitionId
ORDER BY QuerySortOrder;
