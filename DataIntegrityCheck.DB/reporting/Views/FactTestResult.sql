

-- reporting.FactTestExecutionEvaluation
-- 
-- Denormalized view of Test Execution Details
--
--  
--
--
-- SELECT [FIELD LIST] FROM reporting.FactTestExecutionEvaluation
--
--------------------------------------------------------------------------------
-- Change History
--------------------------------------------------------------------------------
-- Version  Date       	Author				Description
-- -------  ---------- 	-----------			------------------------------------
--  1.0			TALAVANT\rob.long			Initial Creation
--------------------------------------------------------------------------------
CREATE VIEW [reporting].[FactTestResult]
AS
    SELECT DISTINCT CONVERT(
               VARCHAR(40)
             , HASHBYTES(
                   'md5'
                 , CAST(td.TestGroupId AS VARCHAR(10)) + '.'
                   + CAST(td.TestDefinitionId AS VARCHAR(10)))
             , 2) TestKey
         , r.TestExecutionId
         , te.StartDateTime TestStart
         , te.EndDateTime TestEnd
         , te.IsSuccess TestIsSuccessful
    FROM   data_testing.TestExecutionResult r
           JOIN data_testing.TestExecution te ON te.TestExecutionId = r.TestExecutionId
           JOIN data_testing.TestAssignment ta ON ta.TestAssignmentId = r.TestAssignmentId
           JOIN data_testing.TestDefinition td ON td.TestDefinitionId = ta.TestDefinitionId
           JOIN data_testing.TestGroup tg ON tg.TestGroupId = td.TestGroupId