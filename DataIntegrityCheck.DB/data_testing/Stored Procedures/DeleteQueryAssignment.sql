-- [data_testing].[DeleteQueryAssignment]
-- 
-- 
--
--  
--
--
-- EXEC [data_testing].[DeleteQueryAssignment]
--
--------------------------------------------------------------------------------
-- Change History
--------------------------------------------------------------------------------
-- Version  Date       	Author				Description
-- -------  ---------- 	-----------			------------------------------------
--  1.0			TALAVANT\rob.long			Initial Creation
--------------------------------------------------------------------------------
CREATE PROCEDURE [data_testing].[DeleteQueryAssignment]
    @ServerName VARCHAR(150)
  , @DatabaseName VARCHAR(150)
  , @QueryName VARCHAR(150)
AS
    BEGIN

        SET NOCOUNT ON;


        --------------------------------------------------------------------------------------------------
        --	DELETE TestExecutionResult
        --------------------------------------------------------------------------------------------------
        DELETE tr
        FROM  [DataCheck].[data_testing].[TestAssignment] ta
              JOIN data_testing.QueryDefinition q ON q.QueryDefinitionId = ta.QueryDefinitionId
              JOIN data_testing.ConnectionDefinition c ON c.ConnectionId = ta.ConnectionId
              JOIN data_testing.TestExecutionResult tr ON tr.TestAssignmentId = ta.TestAssignmentId
        WHERE c.ServerName = @ServerName
              AND c.DatabaseName = @DatabaseName
              AND q.Name = @QueryName;


        --------------------------------------------------------------------------------------------------
        --	DELETE TestAssignment
        --------------------------------------------------------------------------------------------------
        DELETE ta
        FROM  [DataCheck].[data_testing].[TestAssignment] ta
              JOIN data_testing.QueryDefinition q ON q.QueryDefinitionId = ta.QueryDefinitionId
              JOIN data_testing.ConnectionDefinition c ON c.ConnectionId = ta.ConnectionId
        WHERE c.ServerName = @ServerName
              AND c.DatabaseName = @DatabaseName
              AND q.Name = @QueryName;

    END;