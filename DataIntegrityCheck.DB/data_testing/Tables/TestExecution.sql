CREATE TABLE [data_testing].[TestExecution]
    (
        [TestExecutionId] BIGINT IDENTITY(1, 1) NOT NULL
      , [StartDateTime] DATETIME2(7) NOT NULL
      , [EndDateTime] DATETIME2(7) NULL
      , SuccessfulResultGroups INT
	  , FailedResultGroups INT
	  , IsSuccess BIT
      , [CreatedBy] VARCHAR(128)
            CONSTRAINT [DF_TestExecution_CreatedBy]
                DEFAULT ( SUSER_NAME()) NULL
      , CONSTRAINT [PK_TestExecution]
            PRIMARY KEY CLUSTERED ( [TestExecutionId] ASC )
    );



