USE PBS_PROCFIT_ST

CREATE PROCEDURE USP_ST_CARGA_VENDEDOR 
AS

--------------------------------
-- VERIFICAR SE O SCHEMA EXISTE 
---------------------------------

--USE PBS_PROCFIT_ST
IF OBJECT_ID('ST_VENDEDORES') IS NULL 
BEGIN 
	CREATE TABLE ST_VENDEDORES (
	COD_VENDEDOR NUMERIC(15)
 ,	NOME		 VARCHAR(100)
)
END

--LIMPA STAGE AREA 
---------------------
TRUNCATE TABLE ST_VENDEDORES

--- POPULA STAGE AREA 
INSERT INTO ST_VENDEDORES (
COD_VENDEDOR
, NOME	
)
SELECT VENDEDOR
, NOME
FROM PBS_PROCFIT_DADOS.dbo.VENDEDORES

-- ABRE NOVA CONSULTA 
EXEC USP_ST_CARGA_VENDEDOR