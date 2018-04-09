CREATE TABLE [data_testing].[ConnectionDefinition] (
    [ConnectionId]     INT           IDENTITY (1, 1) NOT NULL,
    [ServerName]       VARCHAR (150) NULL,
    [DatabaseName]     VARCHAR (128) NULL,
    [Name]             VARCHAR (50)  NOT NULL,
    [ConnectionString] VARCHAR (250) NOT NULL,
    [CreatedBy]        VARCHAR (128) CONSTRAINT [DF_ConnectionDefinition_CreatedBy] DEFAULT (suser_name()) NULL,
    CONSTRAINT [PK_Connection] PRIMARY KEY CLUSTERED ([ConnectionId] ASC),
    CONSTRAINT [UQ_ConnectionName] UNIQUE NONCLUSTERED ([Name] ASC)
);



