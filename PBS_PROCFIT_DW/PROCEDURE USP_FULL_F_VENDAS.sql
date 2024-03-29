CREATE PROCEDURE USP_FULL_F_VENDAS
AS
IF OBJECT_ID ('F_VENDAS') IS NULL
BEGIN
	CREATE TABLE F_VENDAS (
	 N_DOC			NUMERIC(9)
	,COD_EMPRESA	NUMERIC(15) REFERENCES D_EMPRESA(COD_EMPRESA)
	,COD_CLIENTE	NUMERIC(15) REFERENCES D_CLIENTE(COD_CLIENTE)
	,COD_VENDEDOR	NUMERIC(15)	REFERENCES D_VENDEDORES(COD_VENDEDOR)
	,MOVIMENTO		DATE
	,COD_PRODUTO	NUMERIC(15) REFERENCES D_PRODUTO(COD_PRODUTO)
	,QUANTIDADE		INT
	,VENDA_BRUTA	MONEY
	,DESCONTO_TOTAL	MONEY
	,VENDA_LIQUIDA	MONEY
	)
END

TRUNCATE TABLE F_VENDAS
INSERT INTO F_VENDAS
SELECT * FROM PBS_PROCFIT_ST.dbo.VW_F_VENDAS