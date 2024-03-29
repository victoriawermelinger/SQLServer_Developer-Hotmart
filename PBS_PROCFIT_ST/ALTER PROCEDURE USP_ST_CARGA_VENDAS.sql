ALTER PROCEDURE USP_ST_CARGA_VENDAS(@INCREMENTAL BIT)
/*
@INCREMENTAL = 0 -- CARGA FULL
@INCREMENTAL = 1 -- CARGA INCREMENTAL
*/
AS

--------------------------------
-- VERIFICAR SE O SCHEMA EXISTE 
---------------------------------
--USE PBS_PROCFIT_ST

IF OBJECT_ID('ST_VENDAS') IS NULL 
BEGIN 
		CREATE TABLE ST_VENDAS( 
		N_DOC			NUMERIC(15)
	,	COD_EMPRESA     NUMERIC(15)
	,	COD_CLIENTE  	NUMERIC(15)
	,   COD_VENDEDOR  	NUMERIC(15)
	,	MOVIMENTO		DATE
	,   COD_PRODUTO		NUMERIC(15)
	,	QUANTIDADE		INT
	,	VENDA_BRUTA		MONEY
	,   DESCONTO_TOTAL	MONEY
	,   VENDA_LIQUIDA	MONEY
		)
 END

---LIMPA STAGE AREA 

 TRUNCATE TABLE ST_VENDAS
--- POPULA STAGE AREA 
INSERT INTO ST_VENDAS (
		N_DOC			
	,	COD_EMPRESA     
	,	COD_CLIENTE  	
	,   COD_VENDEDOR  	
	,	MOVIMENTO		
	,   COD_PRODUTO		
	,	QUANTIDADE		
	,	VENDA_BRUTA		
	,   DESCONTO_TOTAL	
	,   VENDA_LIQUIDA
)
--DECLARE @INCREMENTAL BIT = 0
SELECT 
  DOCUMENTO_NUMERO
, EMPRESA
, CLIENTE
, VENDEDOR
, MOVIMENTO 
, PRODUTO
, QUANTIDADE
, VENDA_BRUTA
, DESCONTO + DESCONTO_NEGOCIADO AS DESCONTO
, VENDA_LIQUIDA
FROM PBS_PROCFIT_DADOS.dbo.VENDAS_ANALITICAS
WHERE MOVIMENTO > CASE WHEN @INCREMENTAL = 1 THEN (SELECT MAX (MOVIMENTO) FROM PBS_PROCFIT_DW.dbo.F_VENDAS)
						ELSE '01/01/1900'
					END
