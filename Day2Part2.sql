USE [AdventOfCode2022]
GO

CREATE     PROCEDURE [dbo].[Day2Part2]
	@DayNum int = 2
	, @InputType varchar(7) = 'EXAMPLE'
AS
BEGIN
	/*	
		EXEC Day2Part2 @InputType = 'EXAMPLE';
		EXEC Day2Part2 @InputType = 'PUZZLE';
	*/
	DECLARE @InputData AS varchar(max) = (SELECT InputText FROM Inputs WHERE DayNum = @DayNum AND InputType = @InputType);
	DECLARE @Score AS TABLE (Game varchar(3), Shape int, Outcome int, Total AS (Shape + Outcome));
	INSERT INTO @Score (Game, Shape, Outcome)
	VALUES ('A X', 3, 0)
		, ('A Y', 1, 3)
		, ('A Z', 2, 6)
		, ('B X', 1, 0)
		, ('B Y', 2, 3)
		, ('B Z', 3, 6)
		, ('C X', 2, 0)
		, ('C Y', 3, 3)
		, ('C Z', 1, 6)
	;

	WITH InputTable AS (
		SELECT Seq = CAST([key] AS int), Val = TRIM([value])
		FROM OPENJSON('["' + REPLACE(@InputData, CHAR(10), '","') + '"]')
	)
	SELECT [Procedure] = OBJECT_NAME(@@PROCID)
		, InputType = @InputType
		, answer = (
			SELECT SUM(Total)
			FROM InputTable
			INNER JOIN @Score s
				ON s.Game = InputTable.Val
		)
	;
END
GO

