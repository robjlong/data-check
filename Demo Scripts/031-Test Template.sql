
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
EXEC data_testing.AddTest @Name = 'TEST_NAME' -- Unique Test Name, this should be distinctive
                        , @Description = 'TEST_DESCRIPTION' -- A place holder to define this test.  Make use of this, you'll appreciate it later
                        , @Group = 'GROUP_NAME' -- Put this test in a group to have it executed with other tests at the same time
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
                               , @ServerName = 'SERVER_NAME'			-- The remote server name
                               , @Database = 'DATABASE_NAME'			-- The remote database name
                               , @QueryName = 'QUERY_NAME'				-- A unique query name, keep in mind that a single query may be run against multiple systems
							   , @QuerySortOrder = NULL					-- OPTIONAL : The order placed on the query/connection combination.  This can be used to show "data flow"
							   , @CommandText = ''	

--------------------------------------------------------------------------------------------------
--	No changes needed.
--	Show the overall design of the Test
--------------------------------------------------------------------------------------------------
SELECT  *
FROM    data_testing.TestDesign
WHERE   TestDefinitionId = @TestDefinitionId
ORDER BY QuerySortOrder;
