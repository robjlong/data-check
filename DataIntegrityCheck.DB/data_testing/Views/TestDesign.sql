-- data_testing.TestDesign
-- 
-- Overall design of tests and connections
--
--  
--
--
-- SELECT [FIELD LIST] FROM data_testing.TestDesign
--
--------------------------------------------------------------------------------
-- Change History
--------------------------------------------------------------------------------
-- Version  Date       	Author				Description
-- -------  ---------- 	-----------			------------------------------------
--  1.0		01/14/2016	TALAVANT\rob.long			Initial Creation
--------------------------------------------------------------------------------
CREATE VIEW data_testing.TestDesign
AS
    SELECT map.[TestAssignmentId]
         , tst.Name TestName
         , con.Name ConnectionName
         , qry.Name QueryName
         , qry.CommandText
         , con.ConnectionId
         , map.TestDefinitionId
         , map.QueryDefinitionId
         , map.QuerySortOrder
    FROM   data_testing.[TestAssignment] map
           JOIN data_testing.[ConnectionDefinition] con ON con.ConnectionId = map.ConnectionId
           JOIN data_testing.TestDefinition tst ON tst.TestDefinitionId = map.TestDefinitionId
           JOIN data_testing.QueryDefinition qry ON qry.QueryDefinitionId = map.QueryDefinitionId;
