-- GERAR SENHA DE FORMA AUTOMÁTICA
declare @letras varchar(max) = 'abcdefghijklmnopqrstuwvxzABCDEFGHIJKLMNOPQRSTUWVXZ1234567890!@#$%&*_+=-^<>?~|'
declare @tamanho int = 32;
with cte as (
   			 select    contador = 1,
   					 letra = substring(@letras, 1 + (abs(checksum(newid())) % len(@letras)), 1)
   			 union all
   			 select    contador + 1,
   					 substring(@letras, 1 + (abs(checksum(newid())) % len(@letras)), 1)
   			 from cte
   			 where contador < @tamanho
   		 )

select    (
   		 select    '' + letra
   		 from cte
   		 for xml path(''),
   		 type,
   		 root('txt')
   	 ).value ('/txt[1]', 'varchar(max)')
option(maxrecursion 0)