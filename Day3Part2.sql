USE [AdventOfCode2022]
GO

/****** Object:  StoredProcedure [dbo].[Day3Part2]    Script Date: 12/4/2022 7:58:51 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE   PROCEDURE [dbo].[Day3Part2]
	@DayNum int = 3
	, @InputType varchar(7) = 'EXAMPLE'
AS
BEGIN
	/*	
		EXEC Day3Part2 @InputType = 'EXAMPLE';
		EXEC Day3Part2 @InputType = 'PUZZLE';
		EXEC Day3Part2;
	*/
	DECLARE @InputData AS varchar(max) = (SELECT InputText FROM Inputs WHERE DayNum = @DayNum AND InputType = @InputType);

	WITH InputTable AS (
		SELECT Seq = CAST([key] AS int), Val = TRIM([value]) COLLATE SQL_Latin1_General_CP1_CS_AS
		FROM OPENJSON('["' + REPLACE(@InputData, CHAR(10), '","') + '"]')
	)
	, Rucksacks AS (
		SELECT Seq, Val
		FROM InputTable
	)
	, Badges AS (
		SELECT DISTINCT ElfGroup = Seq / 3, Seq, Item = SUBSTRING(Val, Number, 1), Priority = CASE WHEN ASCII(SUBSTRING(Val, Number, 1)) BETWEEN ASCII('a') AND ASCII('z') THEN ASCII(SUBSTRING(Val, Number, 1)) - 97 + 1 ELSE ASCII(SUBSTRING(Val, Number, 1)) - 65 + 27 END
		FROM Rucksacks
		INNER JOIN Numbers
			ON Number BETWEEN 1 AND LEN(Val)
	)
	SELECT [Procedure] = OBJECT_NAME(@@PROCID)
		, InputType = @InputType
		, answer = (
			SELECT SUM(Priority)
			FROM (
				SELECT ElfGroup, Item, Priority
				FROM Badges
				GROUP BY ElfGroup, Item, Priority
				HAVING COUNT(*) >= 3
			) X
		)
	;
END
GO

