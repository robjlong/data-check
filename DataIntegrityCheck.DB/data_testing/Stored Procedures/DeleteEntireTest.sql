-- [data_testing].[DeleteEntireTest]
-- 
-- CAREFUL!  This deletes everything related to a specific test.  INCLUDING HISTORY
--
--  
--
--
-- EXEC [data_testing].[DeleteEntireTest]
--
--------------------------------------------------------------------------------
-- Change History
--------------------------------------------------------------------------------
-- Version  Date       	Author				Description
-- -------  ---------- 	-----------			------------------------------------
--  1.0				TALAVANT\rob.long			Initial Creation
--------------------------------------------------------------------------------
CREATE PROCEDURE [data_testing].[DeleteEntireTest]
    @TestDefinitionId INT
AS
    BEGIN

        SET NOCOUNT ON;
        SELECT res.TestExecutionResultId
             , res.ResultGroupId
             , res.TestExecutionId
             , res.TestAssignmentId
             , assn.TestDefinitionId
        INTO   #tmp
        FROM   data_testing.TestExecutionResult res
               JOIN data_testing.ExecutionReconciliation recon ON recon.TestExecutionId = res.TestExecutionId
               JOIN data_testing.TestAssignment assn ON assn.TestAssignmentId = res.TestAssignmentId
        WHERE  assn.TestDefinitionId = @TestDefinitionId;

        --------------------------------------------------------------------------------------------------
        --	Removing all Reconciliation Evaluation Records
        --------------------------------------------------------------------------------------------------
        DELETE dst
        FROM data_testing.ExecutionReconciliation dst
             JOIN #tmp src ON src.ResultGroupId = dst.ResultGroupId
                              AND src.TestExecutionId = dst.TestExecutionId;

        --------------------------------------------------------------------------------------------------
        --	Removing all ExecutionResults
        --------------------------------------------------------------------------------------------------
        DELETE dst
        FROM data_testing.TestExecutionResult dst
             JOIN #tmp src ON src.TestExecutionResultId = dst.TestExecutionResultId;

        --------------------------------------------------------------------------------------------------
        --	Removing all Assignments
        --------------------------------------------------------------------------------------------------
        DELETE dst
        FROM data_testing.TestAssignment dst
             JOIN #tmp src ON src.TestAssignmentId = dst.TestAssignmentId;

        --------------------------------------------------------------------------------------------------
        --	Removing the Test itself!
        --------------------------------------------------------------------------------------------------
        DELETE FROM data_testing.TestDefinition
        WHERE TestDefinitionId = @TestDefinitionId;


        --------------------------------------------------------------------------------------------------
        --	Just for run, we'll drop the Temp Table (Responsible)
        --------------------------------------------------------------------------------------------------
        DROP TABLE #tmp;

    END;