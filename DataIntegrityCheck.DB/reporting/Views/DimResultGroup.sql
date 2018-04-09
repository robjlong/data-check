-- reporting.DimResultGroup
-- 
-- Denormalized view of Report Group details
--
--  
--
--
-- SELECT [FIELD LIST] FROM reporting.DimResultGroup
--
--------------------------------------------------------------------------------
-- Change History
--------------------------------------------------------------------------------
-- Version  Date       	Author				Description
-- -------  ---------- 	-----------			------------------------------------
--  1.0			TALAVANT\rob.long			Initial Creation
--------------------------------------------------------------------------------
CREATE VIEW reporting.DimResultGroup
AS
    SELECT CONVERT(
               VARCHAR(40)
             , HASHBYTES('MD5', CAST(rg.ResultGroupId AS VARCHAR(10)))
             , 2) ResultGroupKey
         , Name
         , CreatedBy
    FROM   data_testing.ResultGroup rg;