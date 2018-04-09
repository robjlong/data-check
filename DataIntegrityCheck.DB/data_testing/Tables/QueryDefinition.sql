CREATE TABLE [data_testing].[QueryDefinition] (
    [QueryDefinitionId] INT           IDENTITY (1, 1) NOT NULL,
    [Name]              VARCHAR (150) NOT NULL,
    [Description]       VARCHAR (250) NULL,
    [CommandText]       VARCHAR (MAX) NOT NULL,
    [CreatedBy]         VARCHAR (128) CONSTRAINT [DF_QueryDefinition_CreatedBy] DEFAULT (suser_name()) NULL,
    CONSTRAINT [PK_QueryDefinition] PRIMARY KEY CLUSTERED ([QueryDefinitionId] ASC),
    CONSTRAINT [UQ_QueryDefinitionName] UNIQUE NONCLUSTERED ([Name] ASC)
);





