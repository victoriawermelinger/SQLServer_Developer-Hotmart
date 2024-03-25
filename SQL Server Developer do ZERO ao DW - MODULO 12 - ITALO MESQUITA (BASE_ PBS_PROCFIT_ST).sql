use PBS_PROCFIT_ST

SELECT 
  a.COD_CLIENTE
, a.NOME
, a.NOME_FANTASIA
, ISNULL( b.DESCRICAO,'N�O INFORMADO') AS CLASSIFICACAO_CLIENTE
, ISNULL(c.CIDADE    ,'N�O INFORMADO') AS CIDADE
, ISNULL(d.ESTADO    ,'N�O INFORMADO') AS ESTADO
, ISNULL(c.UF	     ,'ND') AS UF
FROM ST_CLIENTES					 a
LEFT JOIN ST_CLIENTES_CLASSIFICACOES b ON a.COD_CLASSIFICACAO = b.COD_CLASSIFICACAO
LEFT JOIN ST_CLIENTES_ENDERECO		 c ON a.COD_CLIENTE = c.ENTIDADE
LEFT JOIN ST_CLIENTES_ESTADO		 d ON c.UF = d.UF

-- Criando fun��o PascalCase (Aprendendo WHILE)

DECLARE @NOME VARCHAR(100) = 'ITALO MESQUITA VIEIRA'

DECLARE @POSICAO		INT = 1
DECLARE @CHAR			CHAR(1)
DECLARE @CHAR_ANTERIOR  CHAR(1)
DECLARE @NOME_FORMATADO VARCHAR(100) = LOWER(@NOME)

WHILE @POSICAO <= LEN(@NOME)
BEGIN 
     SET @CHAR = SUBSTRING(@NOME, @POSICAO,1)
		SET @CHAR_ANTERIOR = CASE WHEN @POSICAO = 1 THEN ' '
							    ELSE SUBSTRING (@NOME, @POSICAO -1, 1)
							END
		SELECT @CHAR_ANTERIOR, @CHAR 
	 SET @POSICAO = @POSICAO + 1
END


-- Criando fun��o CamalCase (Aprendendo IF + STUFF)

DECLARE @NOME VARCHAR(100) = 'ITALO MESQUITA VIEIRA'

DECLARE @POSICAO		INT = 1
DECLARE @CHAR			CHAR(1)
DECLARE @CHAR_ANTERIOR  CHAR(1)
DECLARE @NOME_FORMATADO VARCHAR(100) = LOWER(@NOME)

WHILE @POSICAO <= LEN(@NOME)
BEGIN 
     SET @CHAR = SUBSTRING(@NOME, @POSICAO,1)
		SET @CHAR_ANTERIOR = CASE WHEN @POSICAO = 1 THEN ' '
							    ELSE SUBSTRING (@NOME, @POSICAO -1, 1)
							END
	 IF @CHAR_ANTERIOR IN('')
	 BEGIN
		SET @NOME_FORMATADO = STUFF(@NOME_FORMATADO, @POSICAO, 1, UPPER(@CHAR))
	 END
	 SET @POSICAO = @POSICAO + 1
END

SELECT @NOME_FORMATADO

-- CREATE FUNCTION FN_CAMEL_CASE (PASTA. FN_CAMEL_CASE)

-- TRATANDO A TABELA COM A FUN��O.
SELECT 
  a.COD_CLIENTE
, a.NOME
, a.NOME_FANTASIA
, ISNULL(DBO.FN_CAMEL_CASE(b.DESCRICAO),'N�o Informado') AS CLASSIFICACAO_CLIENTE
, ISNULL(DBO.FN_CAMEL_CASE(c.CIDADE   ) ,'N�o Informado') AS CIDADE
, ISNULL(DBO.FN_CAMEL_CASE(d.ESTADO   ) ,'N�o Informado') AS ESTADO
, ISNULL(c.UF	     ,'ND') AS UF
FROM ST_CLIENTES					 a
LEFT JOIN ST_CLIENTES_CLASSIFICACOES b ON a.COD_CLASSIFICACAO = b.COD_CLASSIFICACAO
LEFT JOIN ST_CLIENTES_ENDERECO		 c ON a.COD_CLIENTE = c.ENTIDADE
LEFT JOIN ST_CLIENTES_ESTADO		 d ON c.UF = d.UF


-- CRIAR PBS_PROCFIT_DW (OUTRO ARQUIVO MESMO NOME DA DATABASE)

-- CRIANDO UMA VIEW PARA USAR NO PBS_PROCFIT_DW
CREATE VIEW VW_D_CLIENTES

AS

SELECT 
  a.COD_CLIENTE
, a.NOME
, a.NOME_FANTASIA
, ISNULL(DBO.FN_CAMEL_CASE(b.DESCRICAO),'N�o Informado') AS CLASSIFICACAO_CLIENTE
, ISNULL(DBO.FN_CAMEL_CASE(c.CIDADE   ) ,'N�o Informado') AS CIDADE
, ISNULL(DBO.FN_CAMEL_CASE(d.ESTADO   ) ,'N�o Informado') AS ESTADO
, ISNULL(c.UF	     ,'ND') AS UF
FROM ST_CLIENTES					 a
LEFT JOIN ST_CLIENTES_CLASSIFICACOES b ON a.COD_CLASSIFICACAO = b.COD_CLASSIFICACAO
LEFT JOIN ST_CLIENTES_ENDERECO		 c ON a.COD_CLIENTE = c.ENTIDADE
LEFT JOIN ST_CLIENTES_ESTADO		 d ON c.UF = d.UF

--Criando estrutura para dimens�o de empresas
CREATE VIEW VW_D_EMPRESAS

AS

SELECT COD_EMPRESA
, DBO.FN_CAMEL_CASE (NOME)			AS NOME 
, DBO.FN_CAMEL_CASE (NOME_FANTASIA) AS NOME_FANTASIA  
FROM ST_EMPRESAS