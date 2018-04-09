-- [reporting].[ListTestGroups]
-- 
-- Returns all Test Groups for reporting purposes
--
--  
--
--
-- EXEC [reporting].[ListTestGroups]
--
--------------------------------------------------------------------------------
-- Change History
--------------------------------------------------------------------------------
-- Version  Date       	Author				Description
-- -------  ---------- 	-----------			------------------------------------
--  1.0					TALAVANT\rob.long			Initial Creation
--------------------------------------------------------------------------------
CREATE PROCEDURE [reporting].[ListTestGroups]
    @IncludeAll BIT = 0
AS
    BEGIN

        SELECT TestGroupId
             , Name
             , Description
             , CreatedBy
             , 1 SortOrder
        FROM   data_testing.TestGroup
        UNION
        SELECT -1
             , 'ALL'
             , NULL
             , NULL
             , 0
        WHERE  @IncludeAll = 1
        ORDER BY SortOrder
               , Name;
    END;