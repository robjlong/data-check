CREATE TABLE [data_testing].[ResultGroup] (
    [ResultGroupId] INT           IDENTITY (1, 1) NOT NULL,
    [Name]          VARCHAR (500) NULL,
    [CreatedBy]     VARCHAR (128) CONSTRAINT [DF_ResultGroup_CreatedBy] DEFAULT (suser_name()) NULL,
    CONSTRAINT [PK_ResultGroup] PRIMARY KEY CLUSTERED ([ResultGroupId] ASC)
);



