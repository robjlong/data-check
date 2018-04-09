CREATE TABLE [data_testing].[TestAssignment] (
    [TestAssignmentId]  INT           IDENTITY (1, 1) NOT NULL,
    [TestDefinitionId]  INT           NOT NULL,
    [ConnectionId]      INT           NOT NULL,
    [QueryDefinitionId] INT           NOT NULL,
    [CreatedBy]         VARCHAR (128) CONSTRAINT [DF_TestConnectionQueryMapping_CreatedBy] DEFAULT (suser_name()) NULL,
    [QuerySortOrder]    INT           NULL,
    CONSTRAINT [PK_ConnectionTestQuery] PRIMARY KEY CLUSTERED ([TestAssignmentId] ASC),
    CONSTRAINT [TestAssignment__Connection] FOREIGN KEY ([ConnectionId]) REFERENCES [data_testing].[ConnectionDefinition] ([ConnectionId]),
    CONSTRAINT [TestAssignment__QueryDefinition] FOREIGN KEY ([QueryDefinitionId]) REFERENCES [data_testing].[QueryDefinition] ([QueryDefinitionId]),
    CONSTRAINT [TestAssignment__TestDefinition] FOREIGN KEY ([TestDefinitionId]) REFERENCES [data_testing].[TestDefinition] ([TestDefinitionId]),
    CONSTRAINT [UQ_Mapping] UNIQUE NONCLUSTERED ([TestDefinitionId] ASC, [ConnectionId] ASC, [QueryDefinitionId] ASC)
);








GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This column is used in the sorting of the Query / Connection combination in reporting.  This will help show the flow of data between different systems, for example the "Source" would be 1 and the "Data Warehouse" would be 2.', @level0type = N'SCHEMA', @level0name = N'data_testing', @level1type = N'TABLE', @level1name = N'TestAssignment', @level2type = N'COLUMN', @level2name = N'QuerySortOrder';

