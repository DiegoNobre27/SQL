declare
    @contador int,
    @contagemIndices int,
    @manutencao varchar(max)

set @contador = 1
set @contagemIndices =  (
                            SELECT   count(*)
                            FROM SYS.DM_DB_INDEX_PHYSICAL_STATS (DB_ID(), NULL, NULL, NULL, NULL) AS A
                            INNER JOIN SYS.TABLES B ON B.[OBJECT_ID] = A.[OBJECT_ID]
                            INNER JOIN SYS.SCHEMAS C ON C.[SCHEMA_ID] = B.[SCHEMA_ID]
                            INNER JOIN SYS.INDEXES AS D ON D.INDEX_ID = DB_ID() AND A.AVG_FRAGMENTATION_IN_PERCENT > 5 AND D.[NAME] IS NOT NULL
                        )

while @contador <= @contagemIndices
    begin

        use [prod-titulo]
        set @manutencao =   (
                                select  a.Query
                                from    (
                                            SELECT  Linha = ROW_NUMBER() OVER(ORDER BY A.AVG_FRAGMENTATION_IN_PERCENT ASC),
                                                    Query = CASE
                                                                 WHEN A.AVG_FRAGMENTATION_IN_PERCENT >= 30 THEN 'ALTER INDEX ' + D.[NAME] + ' ON ' + C.[NAME] + '.' + B.[NAME] + ' REBUILD'
                                                                 ELSE 'ALTER INDEX ' + D.[NAME] + ' ON ' + C.[NAME] + '.' + B.[NAME] + ' REORGANIZE'
                                                             END
                                            FROM SYS.DM_DB_INDEX_PHYSICAL_STATS (DB_ID(), NULL, NULL, NULL, NULL) AS A
                                            INNER JOIN SYS.TABLES B ON B.[OBJECT_ID] = A.[OBJECT_ID]
                                            INNER JOIN SYS.SCHEMAS C ON C.[SCHEMA_ID] = B.[SCHEMA_ID]
                                            INNER JOIN SYS.INDEXES AS D ON D.INDEX_ID = DB_ID() AND A.AVG_FRAGMENTATION_IN_PERCENT > 5 AND D.[NAME] IS NOT NULL
                                        ) a
                                where a.Linha = @contador
                            )

        exec (@manutencao)
   
        set @contador = @contador + 1
    end

