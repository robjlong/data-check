-- [reporting].[ListTestDefinitions]
-- 
-- Reporting list of all test definitions in a Test Group
--
--  
--
--
-- EXEC [reporting].[ListTestDefinitions]
--
--------------------------------------------------------------------------------
-- Change History
--------------------------------------------------------------------------------
-- Version  Date       	Author				Description
-- -------  ---------- 	-----------			------------------------------------
--  1.0					TALAVANT\rob.long			Initial Creation
--------------------------------------------------------------------------------
CREATE PROCEDURE [reporting].[ListTestDefinitions]
    @TestGroupId INT = NULL
AS
    BEGIN

        SET NOCOUNT ON;

        SELECT td.TestDefinitionId
             , td.[Name] TestName
			 , td.Description
        FROM   data_testing.TestDefinition td
        WHERE  td.TestGroupId = COALESCE(@TestGroupId, td.TestGroupId);

    END;