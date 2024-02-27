use PBS_PROCFIT_DADOS
---MODULO 10---
-- INSERT POSICIONAL 

SELECT * FROM VENDEDORES

/* Faz uma pesquisa dentro da tabela usando alt + f1, onde voc� irar indentificar as colunas. 
que nao aceita valores nulos, ap�s isso fa�a um selec dentro da sua tabela.
para saber quais tem valores e voce poderar usar 

VENDEDOR - OBRIGATORIO
NOME - OBRIGATORIO
ENTIDADE - OBRIGATORIO
EMPRESA_USUARIA
DESCONTO_MAXIMO_PMC
CASATROS_ATIVO
*/

SELECT VENDEDOR ,NOME ,ENTIDADE ,EMPRESA_USUARIA ,DESCONTO_MAXIMO_PMC FROM VENDEDORES
----------------------------------------------------------------------------------------
INSERT INTO VENDEDORES ( VENDEDOR 
,NOME 
,ENTIDADE 
,EMPRESA_USUARIA 
,DESCONTO_MAXIMO_PMC
) VALUES (
'ITALO MESQUITA', 1, 1, 0.00
)
-- ESSE INSERT N�O E HABITUAL USAR, POR QUE SE PRECISAR COLOCARA MAIS DADOS TEM QUE FAZER TODO CODICO NOVAMENTE.
-------------------------------------------------------------------------------------------

--INSERT com Instru��o SELECT

INSERT INTO VENDEDORES 
(NOME, ENTIDADE, EMPRESA_USUARIA, DESCONTO_MAXIMO_PMC)

SELECT NOME
, ENTIDADE
, 1 AS EMPRESA_USUARIA 
, CASE WHEN YEAR (DATA_CADASTRO) <= 2014
	THEN 10.00
	WHEN YEAR (DATA_CADASTRO) = 2015
	THEN 5.00
	ELSE 0.00
 END AS DESCONTO_MAXIMO_PMC
 FROM ENTIDADES
WHERE ENTIDADE BETWEEN 1004 AND 1050

-- 2014 PARA TRAS 10% 
-- 2015 5% DE DESCONTO 
-- DEPOIS DE 2015 0.00

--BEGIN TRANSACTION (BEGIN TRAN) representa um ponto no qual os dados referenciados por uma conexao sao logica e fisicamente consistentes. Se forem encontrados erros, todas as modifica�oes de dados feitas depois do BEGIN TRANSACTION poderao ser revertidas para voltar os dados ao estado conhecido de consistencia
--SELECT * FROM VENDEDORES WITH(NOLOCK)  Se o seu SGBD permitir, utilize NOLOCK quando deseja visualizar dados nao confirmados e nao quando deseja trabalhar somente com os dados que estao confirmados de fato
--ROLLBACK remove todas as altera�oes feitas desde a ultima opera�ao de confirma�ao ou rollback. O sistema tambem libera todos os bloqueios relacionados a transa�ao. 
--COMMIT sao as unidades estruturais de um cronograma de projeto Git.

-- UPDATE 

SELECT DESCONTO_MAXIMO_PMC, * 
FROM VENDEDORES 
WHERE VENDEDOR IN (1,2)

BEGIN TRAN
UPDATE VENDEDORES
SET DESCONTO_MAXIMO_PMC = 100
WHERE VENDEDOR IN (1,2)

BEGIN TRAN 
UPDATE VENDEDORES
SET DESCONTO_MAXIMO_PMC = 0
FROM VENDEDORES 
WHERE VENDEDOR IN (1,2)

-- COMMIT 
-- ROLLBACK

--UPDATE - Atualizando registros com instru��o SELECT

SELECT A.CEP
, B.CEP
, A.ENDERECO AS ENDERECO_ANTIGO 
, B. ENDERECO AS ENDERECO_NOVO
, A. CIDADE AS CIDADE_ANTIGA 
, A. CIDADE AS CIDADE_NOVA
FROM ENDERECOS A
JOIN CEP B ON A.CEP = B.CEP
WHERE B.ENDERECO<> ''
AND B.ENDERECO <> A.ENDERECO

BEGIN TRAN
UPDATE ENDERECOS
SET ENDERECO = B. ENDERECO 
, CIDADE = B.CIDADE
FROM ENDERECOS A
JOIN CEP B ON A.CEP = B.CEP
WHERE B.ENDERECO<> ''

-- COMMIT (REVERTE A OPERA��O)
-- ROLLBACK (CONFIRMA A OPERA��O)

----------------------------------------------------------------------------
--DELETE - Apagando registros

SELECT * FROM VENDEDORES
WHERE VENDEDOR = 23
AND DESCONTO_MAXIMO_PMC = 0

BEGIN TRAN
DELETE VENDEDORES 
 WHERE VENDEDOR = 23
  AND DESCONTO_MAXIMO_PMC = 0

--COMMIT 
--DELETE - Apagando registros com instru��es SELECT

select * from PRODUTOS
select * from MARCAS

select a.MARCA
, b.PRODUTO
from MARCAS a 
left join produtos b on a.MARCA = b.MARCA
where b.PRODUTO is null 

begin tran 
delete 
from MARCAS
from MARCAS a  left join produtos b on a.MARCA = b.MARCA
where b.PRODUTO is null 

begin tran 
delete MARCAS
from MARCAS a  left join produtos b on a.MARCA = b.MARCA
where b.PRODUTO is null 
 
begin tran
delete from MARCAS 
where MARCA in (select a.MARCA
, b.PRODUTO
from MARCAS a 
left join produtos b on a.MARCA = b.MARCA
where b.PRODUTO is null)

begin tran
delete  MARCAS 
where MARCA in (select a.MARCA
, b.PRODUTO
from MARCAS a 
left join produtos b on a.MARCA = b.MARCA
where b.PRODUTO is null)

begin tran
delete  MARCAS 
where MARCA not in (select a.MARCA
, b.PRODUTO
from MARCAS a 
left join produtos b on a.MARCA = b.MARCA
where b.PRODUTO is null)

--rollback 
-----------------------------------------------------------------
-- O comando MERGE
/*  - SICRONIZAR TODAS AS ENTIDADES PF COM A TABELA DE PESSOAS F�SICAS
	- SICRONIZAR TODAS AS ENTIDADES PJ COM A TABELA DE PESSOAS JURITICAS 

-- INSERT --> INSERIR UM NO REGISTRO
-- UPDATE --> ATUALIZAR UM REGISTO
-- DELETE --> APAGA UM REGISTO 
*/

MERGE TABELA_DESTINO D
USING FONTE_DADOS	 O ON D.CAMPO_PRODUTO = O.CAMPO_PRODUTO 

WHEN MATCHED THEN
				UPDATE SET CAMPO_A = CAMPO_B

WHEN NOT MATCHED BY TARGET THEN 
			INSERT (CAMPO_A) 
			VALUES (CAMPO_B)

WHEN NOT MATCHED BY 
SOURCE DELETE; 

-- rotina com INSERT, UPDATE e DELETE 

	-- sicronizar todas as entidades PF com a tabela de pessoas f�sicas 
	-- sicronizar todas as entidades PJ com a tabela de pessoas jur�ticas 
/*
ENTIDADES = PESSOAS_FISICAS + PESSOAS_JURITICAS 
PESSOAS_FISICAS
PESSOAS_JURITICAS 

SELECT * 
FROM ENTIDADES A
LEFT JOIN PESSOAS_FISICAS B ON A.ENTIDADE = B.ENTIDADE
WHERE B.ENTIDADE IS NULL 
 AND LEN(A.INSCRICAO_ESTADUAL)=14
 
 SELECT A.ENTIDADE AS COD_ENT
 , B.ENTIDADE AS COD_PF
 , A.INSCRICAO_FEDERAL
 , B.INSCRICAO_FEDERAL 
 FROM ENTIDADES A 
 FULL JOIN PESSOAS_FISICAS B ON A.ENTIDADE = B.ENTIDADE
 WHERE LEN(A.INSCRICAO_ESTADUAL) = 14
*/

 BEGIN TRANSACTION 

 IF OBJECT_ID('TEMDP..#ATUALIZACAO') IS NOT NULL DROP TABLE #ATUALIZACAO
  
  SELECT A.ENTIDADE AS COD_ENT
 , B.ENTIDADE AS COD_PF
 , CASE WHEN A.ENTIDADE IS NOT NULL
		 AND B.ENTIDADE IS NOT NULL 
		 THEN 'ATUALIZAR'
		WHEN B.ENTIDADE IS NULL 
		 THEN 'INCLUIR'
		 ELSE 'APAGAR' 
END AS ACAO
INTO #ATUALIZACAO
 FROM ENTIDADES A 
 FULL JOIN PESSOAS_FISICAS B ON A.ENTIDADE = B.ENTIDADE
 WHERE LEN(A.INSCRICAO_ESTADUAL) = 14

 select * from #ATUALIZACAO
 /*
 SELECT * FROM #ATUALIZACAO
 WHERE ACAO = 'INCLUIR'


  SELECT * FROM #ATUALIZACAO
 WHERE ACAO = 'ATUALIZAR'
 */

INSERT INTO PESSOAS_FISICAS ( 
ENTIDADE
,NOME
,NOME_FANTASIA
,INSCRICAO_FEDERAL
,INSCRICAO_ESTADUAL
,DATA_HORA_INCLUSAO
,CADASTRO_ATIVO
,CLASSIFICACAO_CLIENTE
,DATA_CADASTRO
)

select b. ENTIDADE
, b.NOME
, b.NOME_FANTASIA
, b.INSCRICAO_FEDERAL
, b.INSCRICAO_ESTADUAL
, getdate () as DATA_HORA_INCLUSAO
, isnull (b.ATIVO, 'S')
, b.CLASSIFICACAO_CLIENTE
, b.DATA_CADASTRO
from #ATUALIZACAO a
join ENTIDADES	  b on a.COD_ENT = b.ENTIDADE
where ACAO = 'incluir'

ROLLBACK