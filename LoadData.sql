USE [AdventOfCode2022]
GO

CREATE PROCEDURE [dbo].[LoadData]
	@DayNum AS int
AS
BEGIN
	/*
		EXEC [dbo].[LoadData] 1
	*/
	SET NOCOUNT ON;
	DECLARE @InputName AS nvarchar(max) = 'K:\Code\AdventOfCode2022\Day' + FORMAT(@DayNum, '00') + '.input.txt';
	DECLARE @ExampleName AS nvarchar(max) = 'K:\Code\AdventOfCode2022\Day' + FORMAT(@DayNum, '00') + '.example.txt';

	DELETE FROM Inputs WHERE DayNum = @DayNum;

	DECLARE @Sql AS nvarchar(max) = N'
	INSERT INTO Inputs (DayNum, InputType, InputText)
	SELECT ' + CAST(@DayNum AS nvarchar(max)) + ', ''PUZZLE'', BulkColumn
	FROM OPENROWSET(BULK ''' + @InputName + ''', SINGLE_BLOB) AS ExternalFile;

	INSERT INTO Inputs (DayNum, InputType, InputText)
	SELECT ' + CAST(@DayNum AS nvarchar(max)) + ', ''EXAMPLE'', BulkColumn
	FROM OPENROWSET(BULK ''' + @ExampleName + ''', SINGLE_BLOB) AS ExternalFile;
	';

	EXEC (@Sql);
END
GO

