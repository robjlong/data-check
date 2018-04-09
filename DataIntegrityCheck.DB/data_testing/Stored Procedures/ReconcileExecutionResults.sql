-- [data_testing].[ReconcileExecutionResults]
-- 
-- Summarizes execution results
--
--  
--
--
-- EXEC [data_testing].[ReconcileExecutionResults]
--
--------------------------------------------------------------------------------
-- Change History
--------------------------------------------------------------------------------
-- Version  Date       	Author				Description
-- -------  ---------- 	-----------			------------------------------------
--  1.0					TALAVANT\rob.long			Initial Creation
--------------------------------------------------------------------------------
CREATE PROCEDURE [data_testing].[ReconcileExecutionResults]
    @TestExecitionId BIGINT
AS
    BEGIN

        SET NOCOUNT ON;
        DECLARE @NullResultCount INT;
        DECLARE @ExpectedResultCount INT; -- Determines how many results we should expect per group (1 per connection)
        --------------------------------------------------------------------------------------------------
        --	Checking for NULL values
        --------------------------------------------------------------------------------------------------
        SELECT @NullResultCount = COUNT(TestExecutionResultId)
             , @ExpectedResultCount = COUNT(DISTINCT ( TestAssignmentId ))
        FROM   data_testing.TestExecutionResult
        WHERE  TestExecutionId = @TestExecitionId
               AND Value IS NULL;

        SELECT @ExpectedResultCount = COUNT(DISTINCT ( TestAssignmentId ))
        FROM   data_testing.TestExecutionResult
        WHERE  TestExecutionId = @TestExecitionId;

        --SELECT @NullResultCount
        --     , @ExpectedResultCount;

        --------------------------------------------------------------------------------------------------
        --	Checking for Expected Result Count
        --------------------------------------------------------------------------------------------------


        INSERT INTO data_testing.ExecutionReconciliation ( [TestExecutionId]
                                                         , DurationInMilliseconds
                                                         , MinValue
                                                         , MaxValue
                                                         , AvgValue
                                                         , ExpectedResultCount
                                                         , ResultCount
                                                         , IsSuccess
                                                         , Variance
                                                         , ResultGroupId )
                    SELECT   tr.TestExecutionId
                           , DATEDIFF(
                                 MILLISECOND ,te.StartDateTime, te.EndDateTime) DurationInMilliseconds
                           , MIN(Value) MinValue
                           , MAX(Value) MaxValue
                           , AVG(Value) AvgValue
                           , @ExpectedResultCount
                           , COUNT(TestExecutionResultId) ResultCount
                           , CAST(CASE WHEN MAX(Value) - MIN(Value) = 0
                                            AND @NullResultCount = 0
                                            AND COUNT(tr.TestExecutionResultId) = @ExpectedResultCount THEN
                                           1
                                       ELSE 0
                                  END AS BIT) IsSuccess
                           , MAX(Value) - MIN(Value) Variance
                           , tr.ResultGroupId
                    FROM     data_testing.TestExecutionResult tr
                             JOIN data_testing.TestExecution te ON te.TestExecutionId = tr.TestExecutionId
                    WHERE    tr.TestExecutionId = @TestExecitionId
                    GROUP BY tr.TestExecutionId
                           , te.StartDateTime
                           , te.EndDateTime
                           , tr.ResultGroupId;

        --------------------------------------------------------------------------------------------------
        --	UPDATE Test Execution Detail with the aggregates from the result reconciliation.
        --------------------------------------------------------------------------------------------------

        WITH aggregates
        AS ( SELECT   SUM(CASE WHEN r.IsSuccess = 1 THEN 1
                          END) SuccessfulResultCount
                    , SUM(CASE WHEN r.IsSuccess = 0 THEN 1
                          END) FailedResultCount
                    , r.TestExecutionId
             FROM     data_testing.ExecutionReconciliation r
             WHERE    r.TestExecutionId = @TestExecitionId
             GROUP BY r.TestExecutionId )
        UPDATE te
        SET    SuccessfulResultGroups = r.SuccessfulResultCount
             , FailedResultGroups = r.FailedResultCount
             , te.IsSuccess = CASE WHEN ISNULL(r.FailedResultCount, 0) > 0 THEN
                                       0
                                   ELSE 1
                              END
        FROM   aggregates r
               JOIN data_testing.TestExecution te ON te.TestExecutionId = r.TestExecutionId;

    END;
