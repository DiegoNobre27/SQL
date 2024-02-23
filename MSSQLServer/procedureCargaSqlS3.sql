declare
	@prefixoBanco varchar(5),
	@diaSemana int,
	@hora varchar(4),
	@contagemBanco int,
	@contador int,
	@banco varchar(50),
	@arn varchar(max),
	@arquivo varchar(100)
	
set @prefixoBanco = ''
set @diaSemana = (select DATEPART(weekday, getdate()))
set @hora = (select convert(varchar(5), dateadd(hour, -3, getdate()),114))
set @contagemBanco = 	(
							SELECT count(*)
							FROM SYS.DATABASES
							WHERE NAME LIKE @prefixoBanco + '%'
						)
set @contador = 1
-- Usando banco master
use master
--go
if @diaSemana not in (1,7) -- Excluindo sábado e domingo
	begin
		if @hora between '08:00' and '20:00' -- Informando o intervalo de bkps
			while @contador <= @contagemBanco -- Loop vai até o número de tabelas
				begin
					set @banco = 	( -- Pegando banco a banco
										select a.Name
										from 	(
													SELECT LINHA = ROW_NUMBER() OVER(ORDER BY name ASC),
															NAME
													FROM SYS.DATABASES
													WHERE NAME LIKE @prefixoBanco + '%'
												) a
										where LINHA = @contador
									)
					
					set @arquivo = @banco + '.bak'
					set @arn = 'ARN_S3' + @prefixoBanco + '/DIFF_' + @arquivo
					
					execute msdb.dbo.rds_backup_database
						@source_db_name = @banco,
						@s3_arn_to_backup_to = @arn,
						@overwrite_s3_backup_file = 1,
						@type = 'DIFFERENTIAL'
							
					set @contador = @contador + 1
				end
		
		if @hora >= '21:00'
			while @contador <= @contagemBanco
				begin
					set @banco = 	(
										select a.Name
										from 	(
													SELECT LINHA = ROW_NUMBER() OVER(ORDER BY name ASC),
															NAME
													FROM SYS.DATABASES
													WHERE NAME LIKE @prefixoBanco + '%'
												) a
										where LINHA = @contador
									)
					
					set @arquivo = @banco + '.bak'
					set @arn = 'ARN_S3' + @prefixoBanco + '/FULL_' + @arquivo
					
					execute msdb.dbo.rds_backup_database
						@source_db_name = @banco,
						@s3_arn_to_backup_to = @arn,
						@overwrite_s3_backup_file = 1,
						@type = 'FULL'
							
					set @contador = @contador + 1
				end
	end
if @diaSemana <> 7 -- executando no sabado
	begin
		if @hora between '08:00' and '14:00'
			while @contador <= @contagemBanco
				begin
					set @banco = 	(
										select a.Name
										from 	(
													SELECT LINHA = ROW_NUMBER() OVER(ORDER BY name ASC),
															NAME
													FROM SYS.DATABASES
													WHERE NAME LIKE @prefixoBanco + '%'
												) a
										where LINHA = @contador
									)
					
					set @arquivo = @banco + '.bak'
					set @arn = 'ARN_S3' + @prefixoBanco + '/DIFF_' + @arquivo
					
					execute msdb.dbo.rds_backup_database
						@source_db_name = @banco,
						@s3_arn_to_backup_to = @arn,
						@overwrite_s3_backup_file = 1,
						@type = 'DIFFERENTIAL'
					
					set @contador = @contador + 1
				end
		if @hora <= '15:00'
			while @contador <= @contagemBanco
				begin
					set @banco = 	(
										select a.Name
										from 	(
													SELECT LINHA = ROW_NUMBER() OVER(ORDER BY name ASC),
															NAME
													FROM SYS.DATABASES
													WHERE NAME LIKE @prefixoBanco + '%'
												) a
										where LINHA = @contador
									)
					
					set @arquivo = @banco + '.bak'
					set @arn = 'ARN_S3' + @prefixoBanco + '/FULL_' + @arquivo
					
					execute msdb.dbo.rds_backup_database
						@source_db_name = @banco,
						@s3_arn_to_backup_to = @arn,
						@overwrite_s3_backup_file = 1,
						@type = 'FULL'
					
					set @contador = @contador + 1
				end
	end

