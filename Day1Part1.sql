USE [AdventOfCode2022]
GO

CREATE   PROCEDURE [dbo].[Day1Part1]
	@DayNum int = 1
	, @InputType varchar(7) = 'EXAMPLE'
AS
BEGIN
	/*	
		EXEC Day1Part1 @InputType = 'EXAMPLE';
		EXEC Day1Part1 @InputType = 'PUZZLE';
	*/
	DECLARE @InputData AS varchar(max) = (SELECT InputText FROM Inputs WHERE DayNum = @DayNum AND InputType = @InputType);

	WITH InputTable AS (
		SELECT Seq = CAST([key] AS int), Calories = CAST(NULLIF(CAST(TRIM([value]) AS nvarchar(max)), '') AS int)
		FROM OPENJSON('["' + REPLACE(@InputData, CHAR(10), '","') + '"]')
	)
	, Details AS (
		SELECT *
			, Elf = 1 + (SELECT COUNT(*) FROM InputTable p WHERE p.Seq < c.Seq AND Calories IS NULL)
		FROM InputTable c
		WHERE c.Calories IS NOT NULL
	)
	SELECT [Procedure] = OBJECT_NAME(@@PROCID)
		, InputType = @InputType
		, answer = (
			SELECT TOP 1 SUM(Calories)
			FROM Details
			GROUP BY Elf
			ORDER BY SUM(Calories) DESC
		)
	;
END
GO

