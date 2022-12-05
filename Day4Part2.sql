USE [AdventOfCode2022]
GO

/****** Object:  StoredProcedure [dbo].[Day4Part2]    Script Date: 12/4/2022 8:16:08 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE    PROCEDURE [dbo].[Day4Part2]
	@DayNum int = 4
	, @InputType varchar(7) = 'EXAMPLE'
AS
BEGIN
	/*	
		EXEC Day4Part2 @InputType = 'EXAMPLE';
		EXEC Day4Part2 @InputType = 'PUZZLE';
		EXEC Day4Part2;
	*/
	DECLARE @InputData AS varchar(max) = (SELECT InputText FROM Inputs WHERE DayNum = @DayNum AND InputType = @InputType);

	WITH InputTable AS (
		SELECT Seq = CAST([key] AS int), Val = TRIM([value])
		FROM OPENJSON('["' + REPLACE(@InputData, CHAR(10), '","') + '"]')
	)
	, Elves AS (
		SELECT *
			, Elf1 = LEFT(Val, CHARINDEX(',', Val, 1) - 1)
			, Elf2 = RIGHT(Val, LEN(Val) - CHARINDEX(',', Val, 1))
		FROM InputTable
	)
	, Breakdown AS (
		SELECT *
			, Elf1_Start = CAST(LEFT(Elf1, CHARINDEX('-', Elf1, 1) - 1) AS int)
			, Elf1_End = CAST(RIGHT(Elf1, LEN(Elf1) - CHARINDEX('-', Elf1, 1)) AS int)
			, Elf2_Start = CAST(LEFT(Elf2, CHARINDEX('-', Elf2, 1) - 1) AS int)
			, Elf2_End = CAST(RIGHT(Elf2, LEN(Elf2) - CHARINDEX('-', Elf2, 1)) AS int)
		FROM Elves
	)
	SELECT [Procedure] = OBJECT_NAME(@@PROCID)
		, InputType = @InputType
		, answer = (
			SELECT COUNT(*)
			FROM Breakdown
			WHERE (
					Elf1_Start BETWEEN Elf2_Start AND Elf2_End
					OR Elf1_End BETWEEN Elf2_Start AND Elf2_End
				)
				OR (
					Elf2_Start BETWEEN Elf1_Start AND Elf1_End
					OR Elf2_End BETWEEN Elf1_Start AND Elf1_End
				)
		)
	;
END
GO

