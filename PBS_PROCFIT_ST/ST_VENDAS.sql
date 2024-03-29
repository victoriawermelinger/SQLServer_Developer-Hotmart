USE PBS_PROCFIT_ST 

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

 TRUNCATE TABLE ST_VENDAS

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