/*
Post-Deployment Script Template							
--------------------------------------------------------------------------------------
 This file contains SQL statements that will be appended to the build script.		
 Use SQLCMD syntax to include a file in the post-deployment script.			
 Example:      :r .\myfile.sql								
 Use SQLCMD syntax to reference a variable in the post-deployment script.		
 Example:      :setvar TableName MyTable							
               SELECT * FROM [$(TableName)]					
--------------------------------------------------------------------------------------
*/

--------------------------------------------------------------------------------------------------
--	Adding a NULL Result Group if one doesn't exist
--------------------------------------------------------------------------------------------------
IF NOT EXISTS ( SELECT  *
                FROM    data_testing.ResultGroup
                WHERE   Name IS NULL )
    INSERT  INTO data_testing.ResultGroup
            ( Name )
    VALUES  ( NULL );