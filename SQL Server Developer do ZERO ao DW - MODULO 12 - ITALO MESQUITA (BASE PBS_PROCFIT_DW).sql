--CREATE DATABASE PBS_PROCFIT_DW
--USE PBS_PROCFIT_DW


IF OBJECT_ID('D_CLIENTE') IS NULL
BEGIN
CREATE TABLE D_CLIENTE(
  COD_CLIENTE   NUMERIC (15) PRIMARY KEY
, NOME          VARCHAR (160)
, NOME_FANTASIA VARCHAR (80)
, CLASSIFICACAO VARCHAR (160)
, CIDADE		VARCHAR (80)
, ESTADO		VARCHAR (80)
, UF			CHAR (2)
)
END

-- Gerando dimens�o D_CLIENTE com TRUNCATE_INSERT
TRUNCATE TABLE D_CLIENTE

INSERT INTO D_CLIENTE

SELECT*FROM PBS_PROCFIT_ST.dbo.VW_D_CLIENTES

-- Gerando dimens�o D_CLIENTE com MERGE

DO
, UF				= o.UF											
														
--QUANDO N�O COINCIDIR NO DESTINO 
WHEN NOT MATCHED BY TARGET THEN INSERT (
  NOME				
, NOME_FANTASIA 	
, CLASSIFICACAO		
, CIDADE 			
, ESTADO 			
, UF
)
VALUES (
  o.NOME
, o.NOME_FANTASIA
, o.CLASSIFICACAO_CLIENTE
, o.CIDADE
, o.ESTADO
, o.UF	
)
--QUANDO N�O COINCIDIR NA FONTE 
WHEN NOT MATCHED BY SOURCE THEN DELETE;











