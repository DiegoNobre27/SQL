-- FUNÇÃO QUE COLOCA A PRIMEIRA LETRA, DE CADA PALAVRA DA STRING,
--MAIÚSCULA E O RESTANTE MINÚSCULA
CREATE FUNCTION Captalize(@string VARCHAR(max))
RETURNS VARCHAR(1000)
AS
BEGIN
    DECLARE @ReturnValue varchar(1000);
    
    ; WITH [CTE] AS (
      SELECT CAST(upper(Left(@string,1)) + lower(substring(@string,2,len(@string))) AS VARCHAR(100)) AS TEXT,
         	CHARINDEX(' ',@string) AS NEXT_SPACE
      UNION ALL
      SELECT CAST(Left(TEXT,NEXT_SPACE) + upper(SubString(TEXT,NEXT_SPACE+1,1)) + SubString(TEXT,NEXT_SPACE+2,1000) AS VARCHAR(100)),
         	CHARINDEX(' ',TEXT, NEXT_SPACE+1)
      FROM [CTE]
      WHERE NEXT_SPACE <> 0
    )

    SELECT @ReturnValue = TEXT
    FROM [CTE]
    WHERE NEXT_SPACE = 0
    
    return @ReturnValue
END
