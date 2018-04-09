CREATE TABLE [data_testing].[TestDefinition] (
    [TestDefinitionId] INT           IDENTITY (1, 1) NOT NULL,
	[TestGroupId] INT CONSTRAINT FK_TestDefinition__TestGroup FOREIGN KEY REFERENCES data_testing.TestGroup,
    [Name]             VARCHAR (250) NOT NULL,
    [Description]      VARCHAR (500) NULL,
    [CreatedBy]        VARCHAR (128) CONSTRAINT [DF_TestDefinition_CreatedBy] DEFAULT (suser_name()) NULL,
    [IsActive] BIT NOT NULL CONSTRAINT [DF_TestDefinition_IsActive] DEFAULT (1), 
    CONSTRAINT [PK_TestDefinition] PRIMARY KEY CLUSTERED ([TestDefinitionId] ASC),
    CONSTRAINT [UQ_TestDefinitionName] UNIQUE NONCLUSTERED ([Name] ASC)
);





