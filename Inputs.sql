USE [AdventOfCode2022]
GO

CREATE TABLE [dbo].[Inputs](
	[DayNum] [int] NOT NULL,
	[InputType] [varchar](7) NOT NULL,
	[InputText] [varchar](max) NOT NULL,
 CONSTRAINT [PK_Inputs] PRIMARY KEY CLUSTERED 
(
	[DayNum] ASC,
	[InputType] ASC
)
)
;
GO

