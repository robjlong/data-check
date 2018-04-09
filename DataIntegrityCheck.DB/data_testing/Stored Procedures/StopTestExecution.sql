-- [data_testing].[StopTestExecution]
-- 
-- Stops a test execution
--
--  
--
--
-- EXEC [data_testing].[StopTestExecution]
--
--------------------------------------------------------------------------------
-- Change History
--------------------------------------------------------------------------------
-- Version  Date       	Author				Description
-- -------  ---------- 	-----------			------------------------------------
--  1.0					TALAVANT\rob.long			Initial Creation
--------------------------------------------------------------------------------
CREATE PROCEDURE [data_testing].[StopTestExecution]
    @TestExecutionId BIGINT
AS
    BEGIN
	
        SET NOCOUNT ON;
--------------------------------------------------------------------------------------------------
--	Setting the EndDateTime of the Test Execution record
--------------------------------------------------------------------------------------------------
        UPDATE  data_testing.TestExecution
        SET     EndDateTime = SYSDATETIME()
        WHERE   TestExecutionId = @TestExecutionId;

--------------------------------------------------------------------------------------------------
--	Summarizing results for the Test Execution
--------------------------------------------------------------------------------------------------
        EXEC [data_testing].[ReconcileExecutionResults] @TestExecutionId;

    END;