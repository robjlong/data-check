-- [reporting].[LatestTestExecutionDetail]
-- 
-- Returns all data about the last execution for a specific test.
--
--  
--
--
-- EXEC [reporting].[LatestTestExecutionDetail]
--
--------------------------------------------------------------------------------
-- Change History
--------------------------------------------------------------------------------
-- Version  Date       	Author				Description
-- -------  ---------- 	-----------			------------------------------------
--  1.0					TALAVANT\rob.long			Initial Creation
--------------------------------------------------------------------------------
CREATE PROCEDURE [reporting].[LatestTestExecutionDetail]
    @TestDefinitionId INT
  , @IncludeSuccessfulResults BIT = 1
AS
    BEGIN

        SET NOCOUNT ON;

        SELECT   te.TestName
               , te.QueryName
               , te.ConnectionName
               , te.GroupName
               , te.Value
               , te.IsSuccess
               , te.Variance
               , te.TestExecutionStartTime
               , te.TestExecutionEndTime
               , te.ResultStartTime
               , te.ResultEndTime
               , td.CommandText
               , td.ConnectionId
               , td.TestDefinitionId
               , td.QueryDefinitionId
               , td.QuerySortOrder
        FROM     data_testing.LatestTestExecution lte
                 JOIN data_testing.AllTestExecutions te ON te.TestExecutionId = lte.TestExecutionId
                 JOIN data_testing.TestDesign td ON td.[TestAssignmentId] = te.[TestAssignmentId]
        WHERE    lte.TestDefinitionId = @TestDefinitionId
                 AND (   te.IsSuccess = 0
                         OR (   te.IsSuccess = 1
                                AND @IncludeSuccessfulResults = 1 ))
        ORDER BY te.GroupName
               , td.QuerySortOrder
               , td.ConnectionName;

    END;