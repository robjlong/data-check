-- reporting.LatestTestExecutionSummary
-- 
-- Returns the Overall Succues / Failure of the latest Test Executions
--
--  
--
--
-- SELECT [FIELD LIST] FROM reporting.LatestTestExecutionSummary
--
--------------------------------------------------------------------------------
-- Change History
--------------------------------------------------------------------------------
-- Version  Date       	Author				Description
-- -------  ---------- 	-----------			------------------------------------
--  1.0					TALAVANT\rob.long			Initial Creation
--------------------------------------------------------------------------------
CREATE VIEW reporting.LatestTestExecutionSummary
AS
    SELECT   ate.TestName
           , MIN(CAST(ate.IsSuccess AS TINYINT)) IsSuccess
           , ate.TestExecutionStartTime
           , ate.TestExecutionEndTime
           , ate.TestExecutionId
           , ate.TestDefinitionId
    FROM     data_testing.AllTestExecutions ate
             JOIN data_testing.LatestTestExecution lte ON lte.TestDefinitionId = ate.TestDefinitionId
                                                          AND lte.TestExecutionId = ate.TestExecutionId
    GROUP BY ate.TestName
           , ate.TestExecutionStartTime
           , ate.TestExecutionEndTime
           , ate.TestExecutionId
           , ate.TestDefinitionId;