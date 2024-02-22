-- PEGANDO O NOME DE TODOS OS BANCOS DE DADOS QUE EXISTEM NA MASTER
SELECT  NAME,
        DATABASE_ID,
        CREATE_DATE  
FROM SYS.DATABASES
 
--------------------------------------------------------------------------
-- PEGANDO O NOME DE TODAS AS TABELAS QUE EXISTEM NO BANCO DE DADOS
SELECT  *
FROM INFORMATION_SCHEMA.TABLES
 
--------------------------------------------------------------------------
-- VERIFICANDO SE A TABELA EXISTE NO BANCO DE DADOS
IF (
    EXISTS (    SELECT TABLE_NAME
                FROM INFORMATION_SCHEMA.TABLES
                WHERE TABLE_SCHEMA = 'dbo'
                AND  TABLE_NAME = 'testedivida'
            )
    )
BEGIN
    TRUNCATE TABLE testedivida
END
 
--------------------------------------------------------------------------
-- PEGANDO O NOME DAS COLUNAS DA TABELA
SELECT  *
FROM SYS.COLUMNS
WHERE OBJECT_ID = OBJECT_ID('NOME DA TABELA')

--------------------------------------------------------------------------
-- PROCEDURES
select	DISTINCT
		object_name(id)
from syscomments