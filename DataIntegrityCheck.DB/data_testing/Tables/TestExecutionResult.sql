CREATE TABLE [data_testing].[TestExecutionResult] (
    [TestExecutionResultId] BIGINT        IDENTITY (1, 1) NOT NULL,
    [ResultGroupId]         INT           CONSTRAINT [DF__tmp_ms_xx__Resul__6FE99F9F] DEFAULT ((1)) NOT NULL,
    [TestExecutionId]       BIGINT        NULL,
    [TestAssignmentId] INT           NULL,
    [StartDateTime]         DATETIME2 (7) NOT NULL,
    [EndDateTime]           DATETIME2 (7) NULL,
    [Value]                 FLOAT (53)    NULL,
    [CreatedBy]             VARCHAR (128) CONSTRAINT [DF_TestExecutionResult_CreatedBy] DEFAULT (suser_name()) NULL,
    CONSTRAINT [PK_TestExecutionResult] PRIMARY KEY CLUSTERED ([TestExecutionResultId] ASC, [ResultGroupId] ASC),
    CONSTRAINT [FK_TestExecution__TestConnectionQuery] FOREIGN KEY ([TestAssignmentId]) REFERENCES [data_testing].[TestAssignment] ([TestAssignmentId]),
    CONSTRAINT [FK_TestExecutionResult__ResultGroup] FOREIGN KEY ([ResultGroupId]) REFERENCES [data_testing].[ResultGroup] ([ResultGroupId]),
    CONSTRAINT [FK_TestExecutionResult__TextExecution] FOREIGN KEY ([TestExecutionId]) REFERENCES [data_testing].[TestExecution] ([TestExecutionId])
);


GO




