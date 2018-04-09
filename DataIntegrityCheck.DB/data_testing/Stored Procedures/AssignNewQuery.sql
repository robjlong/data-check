
-- [data_testing].[AssignNewQuery]
-- 
-- Assigns a query to a test.
--
--  
--
--
-- EXEC [data_testing].[AssignNewQuery]
--
--------------------------------------------------------------------------------
-- Change History
--------------------------------------------------------------------------------
-- Version  Date       	Author				Description
-- -------  ---------- 	-----------			------------------------------------
--  1.0					Rob Long			Initial Creation
--------------------------------------------------------------------------------
CREATE PROCEDURE [data_testing].[AssignNewQuery]
    @TestDefinitionId INT
  , @ServerName VARCHAR(150)
  , @Database VARCHAR(128)
  , @QueryName VARCHAR(150)
  , @QuerySortOrder INT = NULL
  , @CommandText VARCHAR(MAX) = NULL
AS
    BEGIN

        SET NOCOUNT ON;
        DECLARE @ConnectionId INT;
        DECLARE @QueryId INT;

        DECLARE @msg VARCHAR(MAX);
        SELECT @ConnectionId = ConnectionId
        FROM   data_testing.ConnectionDefinition
        WHERE  ServerName = @ServerName
               AND DatabaseName = @Database;

        IF @ConnectionId IS NULL
            BEGIN
                SET @msg = 'The connection specified couldn''t be found.  Check to make sure the server name & database name are correct.'
                           + CHAR(10) + CHAR(10)
                           + 'The connection can be added by executing the following procedure:'
                           + CHAR(10) + CHAR(10)
                           + 'EXEC data_testing.AddSqlConnection @ServerName = '''
                           + @ServerName + ''' -- varchar(50)' + CHAR(10)
                           + ', @Database = ''' + @Database
                           + '''   -- varchar(128)';
                RAISERROR(@msg, 16, 1);
            END;
        ELSE
            BEGIN

                IF CHARINDEX('Value', @CommandText) = 0
                   AND LEN(@CommandText) > 0
                    BEGIN
                        SET @msg = 'The Query [' + @QueryName
                                   + '] is missing a field called "Value". The Value field is a required field, please check your aliases.';

                        RAISERROR(@msg, 16, 1);
                    END;
                ELSE
                    BEGIN
                        --------------------------------------------------------------------------------------------------
                        --	UPSERT of Query Definition
                        --------------------------------------------------------------------------------------------------
                        MERGE data_testing.QueryDefinition dst
                        USING (   SELECT @QueryName [Name]
                                       , @CommandText CommandText ) AS src
                        ON src.[Name] = dst.[Name]
                        WHEN NOT MATCHED THEN
                            INSERT ( [Name]
                                   , CommandText
                                   , CreatedBy )
                            VALUES ( src.[Name], src.CommandText
                                   , SUSER_NAME())
                        WHEN MATCHED AND dst.CommandText <> src.CommandText
                                         AND src.CommandText <> ''
                                         AND src.CommandText IS NOT NULL THEN
                            UPDATE SET dst.CommandText = src.CommandText;

                        SELECT @QueryId = QueryDefinitionId
                        FROM   data_testing.QueryDefinition
                        WHERE  [Name] = @QueryName;

                        --------------------------------------------------------------------------------------------------
                        --	Adds the assignment of the Test, Connection, and Query, if it doesn't exist
                        --------------------------------------------------------------------------------------------------

                        MERGE data_testing.TestAssignment dst
                        USING (   SELECT @TestDefinitionId TestDefinitionId
                                       , @QueryId QueryId
                                       , @ConnectionId ConnectionId
                                       , @QuerySortOrder QuerySortOrder ) src
                        ON src.TestDefinitionId = dst.TestDefinitionId
                           AND src.QueryId = dst.QueryDefinitionId
                           AND src.ConnectionId = dst.ConnectionId
                        WHEN NOT MATCHED THEN
                            INSERT ( TestDefinitionId
                                   , ConnectionId
                                   , QueryDefinitionId
                                   , QuerySortOrder )
                            VALUES ( src.TestDefinitionId, src.ConnectionId
                                   , src.QueryId, src.QuerySortOrder )
                        WHEN MATCHED AND COALESCE(src.QuerySortOrder, -100) <> COALESCE(
                                                                                   dst.QuerySortOrder
                                                                                 , -100) THEN
                            UPDATE SET dst.QuerySortOrder = src.QuerySortOrder;
                    END;
            END;
    END;