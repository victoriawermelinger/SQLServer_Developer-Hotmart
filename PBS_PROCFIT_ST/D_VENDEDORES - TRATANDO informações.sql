CREATE VIEW VW_D_VENDEDORES
AS 
SELECT COD_VENDEDOR
	   , DBO.FN_CAMEL_CASE(NOME) AS VENDEDOR
  FROM PBS_PROCFIT_ST.dbo.ST_VENDEDORES
