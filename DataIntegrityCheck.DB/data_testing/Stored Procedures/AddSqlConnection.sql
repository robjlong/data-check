-- [data_testing].[AddSqlConnection]
-- 
-- Adds a SQL Server Connection
--
--  
--
--
-- EXEC [data_testing].[AddSqlConnection]
--
--------------------------------------------------------------------------------
-- Change History
--------------------------------------------------------------------------------
-- Version  Date       	Author				Description
-- -------  ---------- 	-----------			------------------------------------
--  1.0					TALAVANT\rob.long			Initial Creation
--------------------------------------------------------------------------------
CREATE PROCEDURE [data_testing].[AddSqlConnection]
    @ServerName VARCHAR(50)
  , @Database VARCHAR(128)
AS
    BEGIN

        SET NOCOUNT ON;

        IF NOT EXISTS (   SELECT *
                          FROM   data_testing.ConnectionDefinition
                          WHERE  ServerName = @ServerName
                                 AND DatabaseName = @Database )
            BEGIN

                DECLARE @ConnectionString VARCHAR(250);

                SELECT @ConnectionString = 'Data Source=' + @ServerName
                                           + ';Initial Catalog=' + @Database
                                           + ';Provider=SQLNCLI11.1;Integrated Security=SSPI;Auto Translate=False;';


                INSERT INTO data_testing.ConnectionDefinition ( Name
                                                              , ConnectionString
                                                              , CreatedBy
                                                              , ServerName
                                                              , DatabaseName )
                VALUES ( CONCAT(@ServerName, ':', @Database)
                       , @ConnectionString, SUSER_NAME(), @ServerName
                       , @Database );
            END;

    END;