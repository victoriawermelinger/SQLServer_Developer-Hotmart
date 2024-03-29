--SINCRONIZAR TODAS AS ENTIDADES PF COM A TABELA DE PESSOAS F�SICAS
--SINCRONIZAR TODAS AS ENTIDADES PJ COM A TABELA DE PESSOAS JUR�DICAS

--SELECT *
--  FROM ENTIDADES A 
--  LEFT JOIN PESSOAS_FISICAS B ON A.ENTIDADE = B.ENTIDADE
--  WHERE B.ENTIDADE IS NULL
--    AND LEN( A.INSCRICAO_FEDERAL ) = 14

DROP TRIGGER TR_ENTIDADES_PESSOAS_FISICAS

IF OBJECT_ID('TEMPDB..#ATUALIZACAO') IS NOT NULL DROP TABLE #ATUALIZACAO

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
  FROM ENTIDADES       A
  FULL
  JOIN PESSOAS_FISICAS B ON A.ENTIDADE = B.ENTIDADE
 WHERE LEN( A.INSCRICAO_FEDERAL ) = 14


INSERT INTO PESSOAS_FISICAS
(
  ENTIDADE
, NOME
, NOME_FANTASIA
, INSCRICAO_FEDERAL
, INSCRICAO_ESTADUAL
, DATA_HORA_INCLUSAO
, CADASTRO_ATIVO
, CLASSIFICACAO_CLIENTE
, DATA_CADASTRO
)

SELECT  B.ENTIDADE
      , B.NOME
      , B.NOME_FANTASIA
      , B.INSCRICAO_FEDERAL
      , B.INSCRICAO_ESTADUAL
      , GETDATE() AS DATA_HORA_INCLUSAO
      , ISNULL( B.ATIVO , 'S' )
      , B.CLASSIFICACAO_CLIENTE
      , B.DATA_CADASTRO
   FROM #ATUALIZACAO A
   JOIN ENTIDADES    B ON A.COD_ENT = B.ENTIDADE
  WHERE ACAO = 'INCLUIR'

 
UPDATE PESSOAS_FISICAS  
   SET NOME					 = B.NOME
     , NOME_FANTASIA		 = B.NOME_FANTASIA
	 , INSCRICAO_FEDERAL	 = B.INSCRICAO_FEDERAL
	 , INSCRICAO_ESTADUAL	 = B.INSCRICAO_ESTADUAL
	 , CADASTRO_ATIVO		 = ISNULL( B.ATIVO , 'S' )
	 , CLASSIFICACAO_CLIENTE = B.CLASSIFICACAO_CLIENTE
   
  FROM #ATUALIZACAO A
  JOIN ENTIDADES    B ON A.COD_ENT = B.ENTIDADE
  WHERE ACAO = 'ATUALIZAR'


DELETE FROM PESSOAS_FISICAS
       FROM PESSOAS_FISICAS A
	   JOIN #ATUALIZACAO    B ON A.ENTIDADE = B.COD_PF
       WHERE ACAO = 'APAGAR'

---------------------------------------------------------
---------------------------------------------------------

IF OBJECT_ID('TEMPDB..#ATUALIZACAO_II') IS NOT NULL DROP TABLE #ATUALIZACAO_II

SELECT ENTIDADE
     , NOME
     , NOME_FANTASIA
     , INSCRICAO_FEDERAL
     , INSCRICAO_ESTADUAL
     , GETDATE() AS DATA_HORA_INCLUSAO
     , ISNULL( ATIVO , 'S' ) AS CADASTRO_ATIVO
     , CLASSIFICACAO_CLIENTE
     , DATA_CADASTRO
  INTO #ATUALIZACAO_II
  FROM ENTIDADES A 
 WHERE LEN( A.INSCRICAO_FEDERAL ) = 14



MERGE PESSOAS_FISICAS D
USING #ATUALIZACAO_II O ON D.ENTIDADE = O.ENTIDADE
WHEN MATCHED THEN 
       UPDATE SET NOME					 = O.NOME
                , NOME_FANTASIA		     = O.NOME_FANTASIA
	            , INSCRICAO_FEDERAL	     = O.INSCRICAO_FEDERAL
	            , INSCRICAO_ESTADUAL	 = O.INSCRICAO_ESTADUAL
	            , CADASTRO_ATIVO		 = O.CADASTRO_ATIVO
	            , CLASSIFICACAO_CLIENTE  = O.CLASSIFICACAO_CLIENTE

WHEN NOT MATCHED BY TARGET THEN
       INSERT
       (
         ENTIDADE
       , NOME
       , NOME_FANTASIA
       , INSCRICAO_FEDERAL
       , INSCRICAO_ESTADUAL
       , DATA_HORA_INCLUSAO
       , CADASTRO_ATIVO
       , CLASSIFICACAO_CLIENTE
       , DATA_CADASTRO
       )
	   VALUES(

	     O.ENTIDADE
       , O.NOME
       , O.NOME_FANTASIA
       , O.INSCRICAO_FEDERAL
       , O.INSCRICAO_ESTADUAL
	   , O.DATA_HORA_INCLUSAO
       , O.CADASTRO_ATIVO
       , O.CLASSIFICACAO_CLIENTE
	   , O.DATA_CADASTRO

	   )

WHEN NOT MATCHED BY SOURCE THEN DELETE;

--------------------------------------------------
--------------------------------------------------

MERGE PESSOAS_JURIDICAS D
USING (
        SELECT ENTIDADE
             , NOME
             , NOME_FANTASIA
             , INSCRICAO_FEDERAL
             , INSCRICAO_ESTADUAL
             , GETDATE() AS DATA_HORA_INCLUSAO
             , ISNULL( ATIVO , 'S' ) AS CADASTRO_ATIVO
             , CLASSIFICACAO_CLIENTE
             , DATA_CADASTRO
			 , 'S' AS EMPRESA_NACIONAL
          FROM ENTIDADES A 
         WHERE LEN( A.INSCRICAO_FEDERAL ) = 18 
		 
	  ) O ON D.ENTIDADE = O.ENTIDADE

WHEN MATCHED THEN UPDATE SET NOME				   = O.NOME
                           , NOME_FANTASIA		   = O.NOME_FANTASIA
						   , INSCRICAO_FEDERAL	   = O.INSCRICAO_FEDERAL
						   , INSCRICAO_ESTADUAL	   = O.INSCRICAO_ESTADUAL
						   , CADASTRO_ATIVO		   = O.CADASTRO_ATIVO
						   , CLASSIFICACAO_CLIENTE = O.CLASSIFICACAO_CLIENTE
						   , EMPRESA_NACIONAL      = O.EMPRESA_NACIONAL

WHEN NOT MATCHED BY TARGET THEN INSERT ( ENTIDADE
                                       , NOME 
								       , NOME_FANTASIA 
								       , INSCRICAO_FEDERAL
								       , INSCRICAO_ESTADUAL
								       , DATA_HORA_INCLUSAO 
								       , CADASTRO_ATIVO
								       , CLASSIFICACAO_CLIENTE 
								       , DATA_CADASTRO
									   , EMPRESA_NACIONAL )

								VALUES ( O.ENTIDADE
                                       , O.NOME 
								       , O.NOME_FANTASIA 
								       , O.INSCRICAO_FEDERAL
								       , O.INSCRICAO_ESTADUAL
								       , O.DATA_HORA_INCLUSAO 
								       , O.CADASTRO_ATIVO
								       , O.CLASSIFICACAO_CLIENTE 
								       , O.DATA_CADASTRO
									   , O.EMPRESA_NACIONAL)

WHEN NOT MATCHED BY SOURCE THEN DELETE;