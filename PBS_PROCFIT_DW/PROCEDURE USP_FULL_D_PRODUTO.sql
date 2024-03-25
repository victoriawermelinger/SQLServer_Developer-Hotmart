CREATE PROCEDURE USP_FULL_D_PRODUTO
AS


IF OBJECT_ID('D_PRODUTO') IS NULL
BEGIN
	CREATE TABLE D_PRODUTO(
  COD_PRODUTO			NUMERIC (15) PRIMARY KEY
, DESCRICAO				VARCHAR (160)
, DESCRICAO_REDUZIDA 	VARCHAR (80)
, FAMILIA 				VARCHAR (80)
, SECAO 				VARCHAR (80)
, GRUPO 				VARCHAR (80)
, SUB_GRUPO 			VARCHAR (80)
, MARCA 				VARCHAR (80))
END

-- LIMPA TABELA DE DIMENS�O

TRUNCATE TABLE D_PRODUTO

-- POPULA DIMENS�O
INSERT INTO D_PRODUTO
SELECT*FROM PBS_PROCFIT_ST.dbo.VW_D_PRODUTOS