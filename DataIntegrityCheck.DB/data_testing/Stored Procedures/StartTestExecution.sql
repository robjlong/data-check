-- [data_testing].[StartTestExecution]
-- 
-- Starts a new Testing Execution
--
--  
--
--
-- EXEC [data_testing].[StartTestExecution]
--
--------------------------------------------------------------------------------
-- Change History
--------------------------------------------------------------------------------
-- Version  Date       	Author				Description
-- -------  ---------- 	-----------			------------------------------------
--  1.0					TALAVANT\rob.long			Initial Creation
--------------------------------------------------------------------------------
CREATE PROCEDURE [data_testing].[StartTestExecution]
    @TestExecutionId BIGINT OUT
AS
    BEGIN
	
        SET NOCOUNT ON;

        INSERT  INTO data_testing.TestExecution
                ( StartDateTime )
        VALUES  ( SYSDATETIME() );

        SELECT  @TestExecutionId = SCOPE_IDENTITY();


    END;