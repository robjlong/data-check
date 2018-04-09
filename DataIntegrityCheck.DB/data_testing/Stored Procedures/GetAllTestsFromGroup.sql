-- [data_testing].[GetAllTestsFromGroup]
-- 
-- Returns a list of Tests for a specific Group
--
--  
--
--
-- EXEC [data_testing].[GetAllTestsFromGroup]
--
--------------------------------------------------------------------------------
-- Change History
--------------------------------------------------------------------------------
-- Version  Date       	Author				Description
-- -------  ---------- 	-----------			------------------------------------
--  1.0				TALAVANT\rob.long			Initial Creation
--------------------------------------------------------------------------------
CREATE PROCEDURE [data_testing].[GetAllTestsFromGroup]
    @TestGroupName VARCHAR(200)
AS
    BEGIN

        SET NOCOUNT ON;

        SELECT td.TestDefinitionId
        FROM   data_testing.TestGroup tg
               JOIN data_testing.TestDefinition td ON td.TestGroupId = tg.TestGroupId
        WHERE  tg.Name = @TestGroupName;

    END;