


-- reporting.DimConnection
-- 
-- Denormalized view of the connection and query specifics
--
--  
--
--
-- SELECT [FIELD LIST] FROM reporting.DimConnection
--
--------------------------------------------------------------------------------
-- Change History
--------------------------------------------------------------------------------
-- Version  Date       	Author				Description
-- -------  ---------- 	-----------			------------------------------------
--  1.0			TALAVANT\rob.long			Initial Creation
--------------------------------------------------------------------------------
CREATE VIEW [reporting].[DimConnection]
AS
    SELECT DISTINCT CONVERT(
                        VARCHAR(40)
                      , HASHBYTES(
                            'MD5'
                          , CAST(ta.ConnectionId AS VARCHAR(10)) + '.'
                            + CAST(ta.QueryDefinitionId AS VARCHAR(10)))
                      , 2) ConnectionKey
         , cd.ServerName
         , cd.DatabaseName
         , qd.Name QueryName
         , qd.CommandText
    FROM   data_testing.TestAssignment ta
           JOIN data_testing.QueryDefinition qd ON qd.QueryDefinitionId = ta.QueryDefinitionId
           JOIN data_testing.ConnectionDefinition cd ON cd.ConnectionId = ta.ConnectionId;