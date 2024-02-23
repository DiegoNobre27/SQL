-- CRIA O USUÁRIO NA MASTER
USE [master]
GO
CREATE LOGIN [usuario] WITH PASSWORD=N'senha', DEFAULT_DATABASE=[master], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO

-- CRIA O USUÁRIO NA BASE DESEJADA
use [BASE_DE_ACESSO]
GO
CREATE USER [usuario] FOR LOGIN [usuario]
GO
ALTER LOGIN [usuario] ENABLE
GO

-- CRIANDO UMA ROLE
EXEC SP_ADDROLE 'ROLE';
GO
-- ADICIONANDO TABELAS A ROLE
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE ON [DBO].[TABELA] TO [ROLE]
GO

-- ADICIONAR UM USUÁRIO A UMA ROLE
ALTER ROLE [ROLE] ADD MEMBER [usuario]
GO

-- MUDANDO O BANCO PADRÃO DE INICIALIZAÇÃO DO USUÁRIO
USE [master]
GO
ALTER LOGIN [usuario] WITH DEFAULT_DATABASE=[BASE_ALTERACAO_PADRAO], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF

-- DELETANDO O USUÁRIO DE UMA ROLE
EXEC sp_droprolemember 'ROLE', 'usuario';