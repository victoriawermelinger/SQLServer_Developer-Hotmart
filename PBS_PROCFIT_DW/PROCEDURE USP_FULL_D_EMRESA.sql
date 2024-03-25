CREATE PROCEDURE USP_FULL_D_EMRESA
AS
-- CRIA TABELA CASO N�O EXISTA
IF OBJECT_ID('D_EMPRESA')IS NULL
BEGIN 
	CREATE TABLE D_EMPRESA(
	COD_EMPRESA	  NUMERIC(15) PRIMARY KEY 
  , NOME		  VARCHAR(160)
  , NOME_FANTASIA VARCHAR(80)
  )
END 

-- LIMPA TABELA DE DIMENS�O 
TRUNCATE TABLE D_EMPRESA 

-- POPULA DIMENS�O
INSERT INTO D_EMPRESA

SELECT*FROM PBS_PROCFIT_ST.dbo.VW_D_EMPRESAS