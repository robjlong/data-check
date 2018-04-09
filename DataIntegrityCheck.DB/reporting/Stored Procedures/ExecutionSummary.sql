-- [reporting].[ExecutionSummary]
-- 
-- Returns the latest execution summary for a TestGroup
--
--  
--
--
-- EXEC [reporting].[ExecutionSummary]
--
--------------------------------------------------------------------------------
-- Change History
--------------------------------------------------------------------------------
-- Version  Date       	Author				Description
-- -------  ---------- 	-----------			------------------------------------
--  1.0					TALAVANT\rob.long			Initial Creation
--------------------------------------------------------------------------------
CREATE PROCEDURE [reporting].[ExecutionSummary]
    @TestGroup INT
AS
    BEGIN

        SET NOCOUNT ON;

        SELECT grp.Name TestGroupName
             , lte.TestName
             , lte.IsSuccess
             , lte.TestExecutionStartTime
             , lte.TestExecutionEndTime
             , lte.TestExecutionId
             , lte.TestDefinitionId
        FROM   reporting.LatestTestExecutionSummary lte
               JOIN data_testing.TestDefinition map ON map.TestDefinitionId = lte.TestDefinitionId
               JOIN data_testing.TestGroup grp ON grp.TestGroupId = map.TestGroupId
        WHERE  (   grp.TestGroupId = @TestGroup
                   OR @TestGroup = -1 )
               AND map.IsActive = 1;

    END;