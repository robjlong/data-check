-- [reporting].[QueryDefinition]
-- 
-- Returns query definition for a specific query
--
--  
--
--
-- EXEC [reporting].[QueryDefinition]
--
--------------------------------------------------------------------------------
-- Change History
--------------------------------------------------------------------------------
-- Version  Date       	Author				Description
-- -------  ---------- 	-----------			------------------------------------
--  1.0					TALAVANT\rob.long			Initial Creation
--------------------------------------------------------------------------------
CREATE PROCEDURE [reporting].[QueryDefinition]
    @QueryDefinitionId INT
AS
    BEGIN
	
        SET NOCOUNT ON;

        SELECT  QueryDefinitionId
              , Name
              , Description
              , CommandText
        FROM    data_testing.QueryDefinition
        WHERE   QueryDefinitionId = @QueryDefinitionId;

    END;