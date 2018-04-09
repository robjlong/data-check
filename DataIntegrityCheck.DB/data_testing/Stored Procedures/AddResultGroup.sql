-- [data_testing].[AddResultGroup]
-- 
-- Adds a new result group.
--
--  
--
--
-- EXEC [data_testing].[AddResultGroup]
--
--------------------------------------------------------------------------------
-- Change History
--------------------------------------------------------------------------------
-- Version  Date       	Author				Description
-- -------  ---------- 	-----------			------------------------------------
--  1.0					TALAVANT\rob.long			Initial Creation
--------------------------------------------------------------------------------
CREATE PROCEDURE [data_testing].[AddResultGroup]
    @GroupName VARCHAR(500)
AS
    BEGIN
	
        SET NOCOUNT ON;
		
        DECLARE @ResultGroupId INT; 

        SELECT  @ResultGroupId = ResultGroupId
        FROM    data_testing.ResultGroup
        WHERE   Name = @GroupName;

        IF @ResultGroupId IS NULL
            BEGIN
                INSERT  INTO data_testing.ResultGroup
                        ( Name )
                VALUES  ( @GroupName );

                SELECT  @ResultGroupId = SCOPE_IDENTITY();
            END;

        RETURN @ResultGroupId;
    END;