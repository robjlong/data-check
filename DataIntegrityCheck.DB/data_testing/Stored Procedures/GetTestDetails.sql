-- [data_testing].[GetTestDetails]
-- 
-- Returns the Connections and Queries for a specified test
--
--  
--
--
-- EXEC [data_testing].[GetTestDetails]
--
--------------------------------------------------------------------------------
-- Change History
--------------------------------------------------------------------------------
-- Version  Date       	Author				Description
-- -------  ---------- 	-----------			------------------------------------
--  1.0					TALAVANT\rob.long			Initial Creation
--------------------------------------------------------------------------------
CREATE PROCEDURE [data_testing].[GetTestDetails]
    @TestDefinitionId INT
AS
    BEGIN

        SET NOCOUNT ON;

        SELECT tq.[TestAssignmentId]
             , c.ConnectionString
             , qd.CommandText
        FROM   data_testing.[TestAssignment] tq
               JOIN data_testing.[ConnectionDefinition] c ON c.ConnectionId = tq.ConnectionId
               JOIN data_testing.QueryDefinition qd ON qd.QueryDefinitionId = tq.[QueryDefinitionId]
        WHERE  tq.TestDefinitionId = @TestDefinitionId;

    END;