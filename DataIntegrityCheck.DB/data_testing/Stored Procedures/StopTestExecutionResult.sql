-- [data_testing].[StopTestExecutionResult]
-- 
-- Loads the result as well as the time stopped
--
--  
--
--
-- EXEC [data_testing].[StopTestExecutionResult]
--
--------------------------------------------------------------------------------
-- Change History
--------------------------------------------------------------------------------
-- Version  Date       	Author				Description
-- -------  ---------- 	-----------			------------------------------------
--  1.0					TALAVANT\rob.long			Initial Creation
--------------------------------------------------------------------------------
CREATE PROCEDURE [data_testing].[StopTestExecutionResult]
    @TestExecutionResultId BIGINT
  , @Value FLOAT
AS
    BEGIN
	
        SET NOCOUNT ON;

        UPDATE  data_testing.TestExecutionResult
        SET     EndDateTime = SYSDATETIME()
              , Value = @Value
        WHERE   TestExecutionResultId = @TestExecutionResultId;

    END;