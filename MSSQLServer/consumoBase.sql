-- Quem está usando o banco de dados
select	[Database]      = cast(db_name(p.dbid) as char(40)),
        [User]          = cast(p.loginame as char(50)),
        [Host]          = cast(p.hostname as char(100)),
        [Program]		= cast(p.program_name as char(100)),
        [LastExecution] = p.last_batch,
		[spId]			=	'Kill ' + convert(varchar(100), p.spid) + ' go ' + 'drop database [' +  cast(db_name(p.dbid) as char(40)) + ']' + ' go'
from master..sysprocesses p
where cast(db_name(p.dbid) as char(40)) like 'uat-%'

-- Consumo
exec sp_whoisactive_3