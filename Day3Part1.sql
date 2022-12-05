USE [AdventOfCode2022]
GO

/****** Object:  StoredProcedure [dbo].[Day3Part1]    Script Date: 12/4/2022 7:58:30 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE   PROCEDURE [dbo].[Day3Part1]
	@DayNum int = 3
	, @InputType varchar(7) = 'EXAMPLE'
AS
BEGIN
	/*	
		EXEC Day3Part1 @InputType = 'EXAMPLE';
		EXEC Day3Part1 @InputType = 'PUZZLE';
		EXEC Day3Part1;
	*/
	DECLARE @InputData AS varchar(max) = (SELECT InputText FROM Inputs WHERE DayNum = @DayNum AND InputType = @InputType);

	WITH InputTable AS (
		SELECT Seq = CAST([key] AS int), Val = TRIM([value]) COLLATE SQL_Latin1_General_CP1_CS_AS
		FROM OPENJSON('["' + REPLACE(@InputData, CHAR(10), '","') + '"]')
	)
	, Compartments AS (
		SELECT Seq, LHC = LEFT(Val, LEN(Val) / 2), RHC = RIGHT(Val, LEN(Val) / 2)
		FROM InputTable
	)
	, Priorities AS (
		SELECT DISTINCT Seq, Item = SUBSTRING(LHC, nl.Number, 1), Priority = CASE WHEN ASCII(SUBSTRING(LHC, nl.Number, 1)) BETWEEN ASCII('a') AND ASCII('z') THEN ASCII(SUBSTRING(LHC, nl.Number, 1)) - 97 + 1 ELSE ASCII(SUBSTRING(LHC, nl.Number, 1)) - 65 + 27 END
		FROM Compartments
		INNER JOIN Numbers nl
			ON nl.Number BETWEEN 1 AND LEN(LHC)
		INNER JOIN Numbers nr
			ON nr.Number BETWEEN 1 AND LEN(RHC)
		WHERE SUBSTRING(LHC, nl.Number, 1) = SUBSTRING(RHC, nr.Number, 1)
	)
	SELECT [Procedure] = OBJECT_NAME(@@PROCID)
		, InputType = @InputType
		, answer = (
			SELECT SUM(Priority)
			FROM Priorities
		)
	;
END
GO

