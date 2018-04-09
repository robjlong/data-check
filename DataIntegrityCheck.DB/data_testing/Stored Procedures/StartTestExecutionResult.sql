-- [data_testing].[StartTestExecutionResult]
-- 
-- Creates a new record, establishes the start time
--
--  
--
--
-- EXEC [data_testing].[StartTestExecutionResult]
--
--------------------------------------------------------------------------------
-- Change History
--------------------------------------------------------------------------------
-- Version  Date       	Author				Description
-- -------  ---------- 	-----------			------------------------------------
--  1.0					TALAVANT\rob.long			Initial Creation
--------------------------------------------------------------------------------
CREATE PROCEDURE [data_testing].[StartTestExecutionResult]
    @TestExecutionId BIGINT
  , @TestAssignmentId INT
  , @TestExecutionResultId BIGINT OUT
AS
    BEGIN
	
        SET NOCOUNT ON;

        INSERT  INTO data_testing.TestExecutionResult
                ( TestExecutionId
                , TestAssignmentId
                , StartDateTime
	            )
        VALUES  ( @TestExecutionId  -- TextExecutionId - bigint
                , @TestAssignmentId  -- TestAssignmentId - int
                , SYSDATETIME()  -- StartDateTime - datetime2
	            );

        SELECT  @TestExecutionResultId = SCOPE_IDENTITY();

    END;