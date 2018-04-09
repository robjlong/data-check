
-- data_testing.LatestTestExecution
-- 
-- Returns the test definition ID along with the latest Execution ID
--
--  
--
--
-- SELECT [FIELD LIST] FROM data_testing.LatestTestExecution
--
--------------------------------------------------------------------------------
-- Change History
--------------------------------------------------------------------------------
-- Version  Date       	Author				Description
-- -------  ---------- 	-----------			------------------------------------
--  1.0					TALAVANT\rob.long			Initial Creation
--------------------------------------------------------------------------------
CREATE VIEW [data_testing].[LatestTestExecution]
AS
    WITH LatestExec
    AS (
       SELECT map.TestDefinitionId
            , te.TestExecutionId
            , ROW_NUMBER() OVER ( PARTITION BY map.TestDefinitionId
                                  ORDER BY te.TestExecutionId DESC ) RowNum
       FROM   data_testing.TestExecution te
              JOIN data_testing.TestExecutionResult result ON result.TestExecutionId = te.TestExecutionId
              JOIN data_testing.[TestAssignment] map ON map.[TestAssignmentId] = result.TestAssignmentId )
    SELECT LatestExec.TestDefinitionId
         , LatestExec.TestExecutionId
    FROM   LatestExec
    WHERE  LatestExec.RowNum = 1;