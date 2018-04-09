-- reporting.DimTest
-- 
-- Denormalized View of Test Details
--
--  
--
--
-- SELECT [FIELD LIST] FROM reporting.DimTest
--
--------------------------------------------------------------------------------
-- Change History
--------------------------------------------------------------------------------
-- Version  Date       	Author				Description
-- -------  ---------- 	-----------			------------------------------------
--  1.0			TALAVANT\rob.long			Initial Creation
--------------------------------------------------------------------------------
CREATE VIEW reporting.DimTest
AS
    SELECT CONVERT(
               VARCHAR(40)
             , HASHBYTES(
                   'md5'
                 , CAST(td.TestGroupId AS VARCHAR(10)) + '.'
                   + CAST(td.TestDefinitionId AS VARCHAR(10)))
             , 2) TestKey
         , tg.Name GroupName
         , tg.Description GroupDescription
         , td.Name TestName
         , td.Description TestDescription
    FROM   data_testing.TestDefinition td
           JOIN data_testing.TestGroup tg ON tg.TestGroupId = td.TestGroupId;