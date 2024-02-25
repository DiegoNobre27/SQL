DECLARE @searchText NVARCHAR(100) = 'tabela de entidade externas';
DECLARE @tableName NVARCHAR(100);
DECLARE @columnName NVARCHAR(100);
DECLARE @sql NVARCHAR(MAX) = '';

-- Criar uma tabela temporária para armazenar os resultados
CREATE TABLE #Results (
    TableName NVARCHAR(100),
    ColumnName NVARCHAR(100),
    SearchTextFound BIT
);

DECLARE table_cursor CURSOR FOR 
SELECT t.name
FROM sys.tables t;

OPEN table_cursor;
FETCH NEXT FROM table_cursor INTO @tableName;

WHILE @@FETCH_STATUS = 0
BEGIN
    DECLARE column_cursor CURSOR FOR 
    SELECT c.name
    FROM sys.columns c
    WHERE OBJECT_NAME(c.object_id) = @tableName;

    OPEN column_cursor;
    FETCH NEXT FROM column_cursor INTO @columnName;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @sql = 
            'IF EXISTS (SELECT 1 FROM ' + QUOTENAME(@tableName) +
            ' WHERE ' + QUOTENAME(@columnName) + ' LIKE ''%' + REPLACE(@searchText, '''', '''''') + '%'')' + CHAR(13) +
            'INSERT INTO #Results (TableName, ColumnName, SearchTextFound)' + CHAR(13) +
            'VALUES (''' + @tableName + ''', ''' + @columnName + ''', 1);' + CHAR(13);

        EXEC sp_executesql @sql;

        FETCH NEXT FROM column_cursor INTO @columnName;
    END

    CLOSE column_cursor;
    DEALLOCATE column_cursor;

    FETCH NEXT FROM table_cursor INTO @tableName;
END

CLOSE table_cursor;
DEALLOCATE table_cursor;

-- Selecionar os resultados da tabela temporária
SELECT *
FROM #Results;


