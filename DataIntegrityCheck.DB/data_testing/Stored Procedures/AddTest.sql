
-- [data_testing].[AddNewTest]
-- 
-- Adds a new test and query using an existing ConnectionId 
--
--  
--
--
-- EXEC [data_testing].[AddNewTest]
--
--------------------------------------------------------------------------------
-- Change History
--------------------------------------------------------------------------------
-- Version  Date       	Author				Description
-- -------  ---------- 	-----------			------------------------------------
--  1.0					TALAVANT\rob.long			Initial Creation
--------------------------------------------------------------------------------
CREATE PROCEDURE [data_testing].[AddTest]
    @Name VARCHAR(250)
  , @Description VARCHAR(500) = NULL
  , @Group VARCHAR(50) = NULL
  , @TestDefinitionId INT OUT
AS
    BEGIN

        SET NOCOUNT ON;
        DECLARE @TestGroupId INT;

        --------------------------------------------------------------------------------------------------
        --	Checking for the Test Group, and assigning it.
        --------------------------------------------------------------------------------------------------
        IF @Group IS NOT NULL
            BEGIN

                MERGE data_testing.TestGroup dst
                USING ( SELECT @Group [Name] ) AS src
                ON dst.Name = src.Name
                WHEN NOT MATCHED THEN INSERT ( Name
                                             , CreatedBy )
                                      VALUES ( src.Name, SUSER_NAME());

                SELECT @TestGroupId = TestGroupId
                FROM   data_testing.TestGroup
                WHERE  Name = @Group;

            END;

        --------------------------------------------------------------------------------------------------
        --	Checking for the test.  If it doesn't exist, it creates it.
        --------------------------------------------------------------------------------------------------


        MERGE data_testing.TestDefinition dst
        USING (   SELECT @TestGroupId TestGroupId
                       , @Name TestName
                       , @Description TestDescription ) AS src
        ON src.TestName = dst.Name
        WHEN MATCHED THEN UPDATE SET dst.Description = src.TestDescription
                                   , dst.TestGroupId = @TestGroupId
        WHEN NOT MATCHED THEN
            INSERT ( TestGroupId
                   , Name
                   , Description
                   , CreatedBy )
            VALUES ( @TestGroupId, src.TestName, src.TestDescription
                   , SUSER_NAME());

		--------------------------------------------------------------------------------------------------
		--	Getting the TestDefinitionID for the Variable
		--------------------------------------------------------------------------------------------------
        SELECT @TestDefinitionId = TestDefinitionId
        FROM   data_testing.TestDefinition
        WHERE  Name = @Name;

    END;