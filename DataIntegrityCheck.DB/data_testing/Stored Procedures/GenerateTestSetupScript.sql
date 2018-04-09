-- [data_testing].[GenerateTestSetupScript]
-- 
-- Returns the setup script for a given test for all assignments.
--
--  
--
--
-- EXEC [data_testing].[GenerateTestSetupScript]
--
--------------------------------------------------------------------------------
-- Change History
--------------------------------------------------------------------------------
-- Version  Date       	Author				Description
-- -------  ---------- 	-----------			------------------------------------
--  1.0					TALAVANT\rob.long			Initial Creation
--------------------------------------------------------------------------------
CREATE PROCEDURE [data_testing].[GenerateTestSetupScript]
    @TestName VARCHAR(500) = NULL
AS
    BEGIN

        SET NOCOUNT ON;

        DECLARE @TestDescription VARCHAR(500)
              , @GroupName VARCHAR(500);


        SELECT @TestDescription = REPLACE(td.Description, '''', '''''')
             , @GroupName = REPLACE(tg.Name, '''', '''''')
        FROM   data_testing.TestDefinition td
               JOIN data_testing.TestGroup tg ON tg.TestGroupId = td.TestGroupId
        WHERE  td.Name = @TestName;

        IF @TestName IS NULL
            BEGIN
                SET @TestName = 'TEST_NAME';
                SET @TestDescription = 'TEST_DESCRIPTION';
                SET @GroupName = 'GROUP_NAME';
            END;


        DECLARE @Script VARCHAR(MAX) = '';
        DECLARE @Header VARCHAR(MAX) = '
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
EXEC data_testing.AddTest @Name = ''$TestName'' -- Unique Test Name, this should be distinctive
                        , @Description = ''$TestDescription'' -- A place holder to define this test.  Make use of this, you''ll appreciate it later
                        , @Group = ''$GroupName'' -- Put this test in a group to have it executed with other tests at the same time
                        , @TestDefinitionId = @TestDefinitionId OUTPUT; -- Used later. No need to adjust this.

--------------------------------------------------------------------------------------------------
--	ASSIGNING QUERY & CONNECTION COMBINATIONS TO THE TEST
--------------------------------------------------------------------------------------------------
'       ;
        SET @Header = REPLACE(
                          @Header
                        , '$TestName'
                        , REPLACE(@TestName, '''', ''''''));
        SET @Header = REPLACE(@Header, '$TestDescription', @TestDescription);
        SET @Header = REPLACE(@Header, '$GroupName', @GroupName);

        SET @Script += @Header;

        /* declare variables */
        DECLARE @ServerName VARCHAR(150)
              , @DatabaseName VARCHAR(128)
              , @QueryName VARCHAR(250)
              , @CommandText VARCHAR(MAX)
              , @QuerySortOrder VARCHAR(150)
              , @ConnectionRepeatNum INT;

        DECLARE TestAssignCursor CURSOR FAST_FORWARD READ_ONLY FOR
            SELECT cd.ServerName
                 , cd.DatabaseName
                 , REPLACE(qd.Name, '''', '''''') QueryName
                 , qd.CommandText CommandText
                 , CAST(assn.QuerySortOrder AS VARCHAR(10)) QuerySortOrder
                 , ROW_NUMBER() OVER ( PARTITION BY assn.QueryDefinitionId
                                       ORDER BY assn.QuerySortOrder
                                              , assn.QueryDefinitionId ) ConnectionRepeatNum
            FROM   data_testing.TestDefinition td
                   JOIN data_testing.TestGroup tg ON tg.TestGroupId = td.TestGroupId
                   JOIN data_testing.TestAssignment assn ON assn.TestDefinitionId = td.TestDefinitionId
                   JOIN data_testing.QueryDefinition qd ON qd.QueryDefinitionId = assn.QueryDefinitionId
                   JOIN data_testing.ConnectionDefinition cd ON cd.ConnectionId = assn.ConnectionId
            WHERE  td.Name = @TestName
            UNION
            SELECT 'SERVER_NAME' ServerName
                 , 'DATABASE_NAME' DatabaseName
                 , 'QUERY_NAME' QueryName
                 , 'COMMAND_TEXT' CommandText
                 , 'NULL' QuerySortOrder
                 , 0 ConnectionRepeatNum
            WHERE  @TestName = 'TEST_NAME'
            ORDER BY QuerySortOrder
                   , ConnectionRepeatNum;

        OPEN TestAssignCursor;

        FETCH NEXT FROM TestAssignCursor
        INTO @ServerName
           , @DatabaseName
           , @QueryName
           , @CommandText
           , @QuerySortOrder
           , @ConnectionRepeatNum;

        WHILE @@FETCH_STATUS = 0
            BEGIN
                DECLARE @Assignment VARCHAR(MAX) = '
--------------------------------------------------------------------------------------------------
--	2.
--	Assigns a query and connection to the test defined above.
--	This section will should be repeated for each result set to be evaluated in the test.
--------------------------------------------------------------------------------------------------
EXEC data_testing.AssignNewQuery @TestDefinitionId = @TestDefinitionId -- int
                               , @ServerName = ''$ServerName''			-- The remote server name
                               , @Database = ''$DatabaseName''			-- The remote database name
                               , @QueryName = ''$QueryName''			-- A unique query name, keep in mind that a single query may be run against multiple systems
							   , @QuerySortOrder = $QuerySortOrder	-- OPTIONAL : The order placed on the query/connection combination.  This can be used to show "data flow"
							   $CommandText	
'               ;

                DECLARE @CommandTextSQL VARCHAR(MAX);

                IF @ConnectionRepeatNum = 1
                    BEGIN

                        SET @CommandTextSQL = ', @CommandText = -- OPTIONAL : The SELECT Statement that meets the needs of the test to return results for evaluation
									''' + REPLACE(@CommandText, '''', '''''')
                                              + ''';
'                       ;
                    END;
                ELSE
                    SET @CommandTextSQL = '';

                SET @Assignment = COALESCE(
                                      REPLACE(
                                          @Assignment
                                        , '$ServerName'
                                        , @ServerName)
                                    , 'SERVER_NAME');
                SET @Assignment = COALESCE(
                                      REPLACE(
                                          @Assignment
                                        , '$DatabaseName'
                                        , @DatabaseName)
                                    , 'DATABASE_NAME');
                SET @Assignment = COALESCE(
                                      REPLACE(
                                          @Assignment
                                        , '$CommandText'
                                        , @CommandTextSQL)
                                    , 'COMMAND_TEXT');
                SET @Assignment = COALESCE(
                                      REPLACE(
                                          @Assignment
                                        , '$QueryName'
                                        , @QueryName)
                                    , 'QUERY_NAME');
                SET @Assignment = REPLACE(
                                      @Assignment
                                    , '$QuerySortOrder'
                                    , COALESCE(@QuerySortOrder, 'NULL'));

                SET @Script += @Assignment;

                FETCH NEXT FROM TestAssignCursor
                INTO @ServerName
                   , @DatabaseName
                   , @QueryName
                   , @CommandText
                   , @QuerySortOrder
                   , @ConnectionRepeatNum;
            END;

        CLOSE TestAssignCursor;
        DEALLOCATE TestAssignCursor;


        SET @Script += '
--------------------------------------------------------------------------------------------------
--	No changes needed.
--	Show the overall design of the Test
--------------------------------------------------------------------------------------------------
SELECT  *
FROM    data_testing.TestDesign
WHERE   TestDefinitionId = @TestDefinitionId
ORDER BY QuerySortOrder;
'       ;

        SELECT @Script ScriptContents;

    END;
GO

