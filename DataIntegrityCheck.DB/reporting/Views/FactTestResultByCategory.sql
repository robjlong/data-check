


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
CREATE VIEW [reporting].[FactTestResultByCategory]
AS
    SELECT DISTINCT CONVERT(
                        VARCHAR(40)
                      , HASHBYTES(
                            'md5'
                          , CAST(td.TestGroupId AS VARCHAR(10)) + '.'
                            + CAST(td.TestDefinitionId AS VARCHAR(10)))
                      , 2) TestKey
         , CONVERT(
               VARCHAR(40)
             , HASHBYTES('MD5', CAST(r.ResultGroupId AS VARCHAR(10)))
             , 2) ResultGroupKey
         , r.TestExecutionId
         , recon.IsSuccess ResultGroupSuccessful
         , recon.MinValue ResultMinValue
         , recon.MaxValue ResultMaxValue
         , recon.AvgValue ResultAvgValue
         , recon.ExpectedResultCount
         , recon.ResultCount ActualResultCount
         , recon.Variance ResultVariance
    FROM   data_testing.TestExecutionResult r
           JOIN data_testing.TestExecution te ON te.TestExecutionId = r.TestExecutionId
           JOIN data_testing.TestAssignment ta ON ta.TestAssignmentId = r.TestAssignmentId
           JOIN data_testing.TestDefinition td ON td.TestDefinitionId = ta.TestDefinitionId
           JOIN data_testing.TestGroup tg ON tg.TestGroupId = td.TestGroupId
           JOIN data_testing.ExecutionReconciliation recon ON recon.TestExecutionId = r.TestExecutionId
                                                              AND recon.ResultGroupId = r.ResultGroupId;