-- data_testing.FailedTestExecutions
-- 
-- Listing of all execurion results with failures.
--
--  
--
--
-- SELECT [FIELD LIST] FROM data_testing.FailedTestExecutions
--
--------------------------------------------------------------------------------
-- Change History
--------------------------------------------------------------------------------
-- Version  Date       	Author				Description
-- -------  ---------- 	-----------			------------------------------------
--  1.0					TALAVANT\rob.long			Initial Creation
--------------------------------------------------------------------------------
CREATE VIEW [data_testing].[FailedTestExecutions]
AS
    SELECT  t.Name TestName
          , q.Name QueryName
          , c.Name ConnectionName
          , grp.Name GroupName
          , res.Value
          , r.IsSuccess
          , r.Variance
          , te.StartDateTime TestExecutionStartTime
          , te.EndDateTime TestExecutionEndTime
          , r.TestExecutionId
          , t.TestDefinitionId
          , c.ConnectionId
          , q.QueryDefinitionId
		  , map.[TestAssignmentId]
    FROM    data_testing.[TestAssignment] map
            JOIN data_testing.TestExecutionResult res ON res.TestAssignmentId = map.[TestAssignmentId]
            JOIN data_testing.TestExecution te ON te.TestExecutionId = res.TestExecutionId
            JOIN data_testing.ExecutionReconciliation r ON r.TestExecutionId = te.TestExecutionId
                                                          AND r.ResultGroupId = res.ResultGroupId
            JOIN data_testing.TestDefinition t ON t.TestDefinitionId = map.TestDefinitionId
            JOIN data_testing.QueryDefinition q ON q.QueryDefinitionId = map.QueryDefinitionId
            JOIN data_testing.ConnectionDefinition c ON c.ConnectionId = map.ConnectionId
            JOIN data_testing.ResultGroup grp ON grp.ResultGroupId = r.ResultGroupId
    WHERE   r.IsSuccess = 0;