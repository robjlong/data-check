CREATE TABLE [data_testing].[TestGroup] (
    [TestGroupId] INT           IDENTITY (1, 1) NOT NULL,
    [Name]        VARCHAR (250) NULL,
    [Description] VARCHAR (500) NULL,
    [CreatedBy]   VARCHAR (128) CONSTRAINT [DF_CreatedBy] DEFAULT (suser_name()) NULL,
    CONSTRAINT [PK_TestGroup] PRIMARY KEY CLUSTERED ([TestGroupId] ASC),
    CONSTRAINT [UQ_TestGroup] UNIQUE NONCLUSTERED ([Name] ASC)
);



