exec dba..pr_kill 'TABELA_DESTINO'
go
drop database [BASE]
go
Exec msdb.dbo.rds_restore_database
@restore_db_name = 'TABELA_DESTINO',
@s3_arn_to_restore_from = 'ARN_S3/ARQUIVO.BAK'
go
