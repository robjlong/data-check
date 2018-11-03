USE DataCheck
GO
--------------------------------------------------------------------------------------------------
--	Adding a new SQL Connection.
--	By default, this is using Integrated Security
--------------------------------------------------------------------------------------------------
EXEC data_testing.AddSqlConnection @ServerName = 'localhost' -- varchar(50)
                                 , @Database = 'WorldWideImporters'   -- varchar(128)

EXEC data_testing.AddSqlConnection @ServerName = 'localhost' -- varchar(50)
                                 , @Database = 'WorldWideImporters_PSE'   -- varchar(128)

EXEC data_testing.AddSqlConnection @ServerName = 'localhost' -- varchar(50)
                                 , @Database = 'WorldWideImportersDW'   -- varchar(128)

SELECT * FROM data_testing.ConnectionDefinition