-- Criando e preenchendo ST_CLIENTES_ENDERECO
/* TABELA DE ENDERECO NO ST 
ENTIDADE
CIDADE
UF
*/
USE PBS_PROCFIT_ST
IF OBJECT_ID('ST_CLIENTES_ENDERECO') IS NULL
BEGIN 
CREATE TABLE ST_CLIENTES_ENDERECO(
 ENTIDADE NUMERIC(15)
, CIDADE  VARCHAR(100)
, UF	  CHAR(2)
)
END

TRUNCATE TABLE ST_CLIENTES_ENDERECO
INSERT INTO ST_CLIENTES_ENDERECO(
ENTIDADE
, CIDADE
, UF	
)
SELECT ENTIDADE
,	   CIDADE
,	   ESTADO
FROM PBS_PROCFIT_DADOS.dbo.ENDERECOS

SELECT * FROM ST_CLIENTES_ENDERECO