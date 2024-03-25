CREATE PROCEDURE USP_ST_CARGA_EMPRESAS
AS

--------------------------------
-- VERIFICAR SE O SCHEMA EXISTE 
---------------------------------

--USE PBS_PROCFIT_ST

IF OBJECT_ID('ST_EMPRESAS') IS NULL 
BEGIN 
	CREATE TABLE ST_EMPRESAS(
	COD_EMPRESA NUMERIC(15)
 , 	NOME		VARCHAR(100)
 ,  NOME_FANTASIA VARCHAR(60)
 )
 END
 --LIMPA STAGE AREA 
---------------------
 TRUNCATE TABLE ST_EMPRESAS

--- POPULA STAGE AREA 
INSERT INTO ST_EMPRESAS (
	COD_EMPRESA   
 , 	NOME		  
 ,  NOME_FANTASIA 
)
SELECT EMPRESA_USUARIA
,NOME
,NOME_FANTASIA
FROM PBS_PROCFIT_DADOS.dbo.EMPRESAS_USUARIAS

-- ABRE NOVA CONSULTA 
EXEC USP_ST_CARGA_EMPRESAS


