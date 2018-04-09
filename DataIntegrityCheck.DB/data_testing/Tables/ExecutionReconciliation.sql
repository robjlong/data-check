CREATE TABLE [data_testing].[ExecutionReconciliation]
    (
        [TestExecutionId] BIGINT NOT NULL
      , [ResultGroupId] INT
            CONSTRAINT [DF__tmp_ms_xx__Resul__6D0D32F4]
                DEFAULT (( 1 )) NOT NULL
      , [DurationInMilliseconds] BIGINT NULL
      , [MinValue] FLOAT(53) NULL
      , [MaxValue] FLOAT(53) NULL
      , [AvgValue] FLOAT(53) NULL
      , [ExpectedResultCount] INT NULL
      , [ResultCount] INT NULL
      , [Variance] FLOAT(53) NULL
      , [IsSuccess] BIT NULL
      , [CreatedBy] VARCHAR(128)
            CONSTRAINT [DF_ExecutionReconciliation_CreatedBy]
                DEFAULT ( SUSER_NAME()) NULL
      , CONSTRAINT [PK_ExecutionReconciliation]
            PRIMARY KEY CLUSTERED
            (
                [TestExecutionId] ASC
              , [ResultGroupId] ASC )
      , CONSTRAINT [FK_ExecutionReconciliation__ResultGroup]
                FOREIGN KEY ( [ResultGroupId] )
                REFERENCES [data_testing].[ResultGroup] ( [ResultGroupId] )
      , CONSTRAINT [FK_ExecutionReconciliation__TestExecution]
                FOREIGN KEY ( [TestExecutionId] )
                REFERENCES [data_testing].[TestExecution]
                (   [TestExecutionId] )
      , CONSTRAINT [UQ_ExecitionId]
            UNIQUE NONCLUSTERED
            (
                [TestExecutionId] ASC
              , [ResultGroupId] ASC )
    );



