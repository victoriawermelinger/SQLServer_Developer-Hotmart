use PBS_PROCFIT_DADOS
-- MODULO 05 --

--INNER JOIN - SO PEGA O QUE TEM NAS DUAS TABELAS. 
SELECT A.VENDEDOR 
,B.EMPRESA_USUARIA
FROM VENDAS_ANALITICAS A
INNER JOIN VENDEDORES B
ON A.VENDEDOR = B.VENDEDOR

--LEFT JOIN / LEFT OUTER JOIN - ELE TRAZ A PARTE DA ESQUERDA E O INNER JOIN
SELECT A.VENDEDOR 
,B.EMPRESA_USUARIA
FROM VENDAS_ANALITICAS A
LEFT JOIN VENDEDORES B
ON A.VENDEDOR = B.VENDEDOR

-- EXCLUIR TUDO QUE TEM NO INNER (WHERE... IS NULL)
SELECT A.VENDEDOR 
,B.EMPRESA_USUARIA
FROM VENDAS_ANALITICAS A
LEFT JOIN VENDEDORES B
ON A.VENDEDOR = B.VENDEDOR
WHERE B.VENDEDOR IS NULL

-- RIGHT JOIN / RIGHT OUTER JOIN - ELE TRAZ A PARTE DA DIREITA E O INNER JOIN
SELECT A.VENDEDOR 
,B.EMPRESA_USUARIA
FROM VENDAS_ANALITICAS A
RIGHT JOIN VENDEDORES B
ON A.VENDEDOR = B.VENDEDOR

-- EXCLUIR TUDO QUE TEM NO INNER (WHERE... IS NULL)
SELECT A.VENDEDOR 
,B.EMPRESA_USUARIA
FROM VENDAS_ANALITICAS A
RIGHT JOIN VENDEDORES B
ON A.VENDEDOR = B.VENDEDOR
WHERE B.VENDEDOR IS NULL

--FULL JOIN / FULL OUTER JOIN - TRAZ OS DADOS DAS DUAS TABELAS 
SELECT A.VENDEDOR 
,B.EMPRESA_USUARIA
FROM VENDAS_ANALITICAS A
FULL OUTER JOIN VENDEDORES B
ON A.VENDEDOR = B.VENDEDOR

--TRAZ OS DADOS DAS DUAS TABELAS SEM O INNER JOIN
SELECT A.VENDEDOR 
,B.EMPRESA_USUARIA
FROM VENDAS_ANALITICAS A
RIGHT JOIN VENDEDORES B
ON A.VENDEDOR = B.VENDEDOR
WHERE B.VENDEDOR IS NULL OR A.VENDEDOR IS NULL

-- COMANDO SP_HELP ou ALT + F1
 SP_HELP PRODUTOS 

--INNER JOIN PODE USAR TAMBEM COMO JOIN 
 SELECT A.VENDEDOR 
 , V.NOME
 , SUM(A.QUANTIDADE) AS QUANTIDADE
 FROM VENDAS_ANALITICAS A 
 INNER JOIN VENDEDORES V
 ON A.VENDEDOR = V.VENDEDOR
 WHERE A.VENDEDOR IN (1,2,3,20)
 GROUP BY A.VENDEDOR , V.NOME
 HAVING SUM (A.QUANTIDADE)> 35840.00
 ORDER BY A.VENDEDOR

 SELECT P.PRODUTO
 , P.DESCRICAO
 , P.FAMILIA_PRODUTO
 , FP.DESCRICAO
 FROM PRODUTOS P
 JOIN FAMILIAS_PRODUTOS FP
 ON P.FAMILIA_PRODUTO = FP.FAMILIA_PRODUTO

 SELECT A.PRODUTO
 , P.DESCRICAO
 , A.QUANTIDADE
 , FP.DESCRICAO
 FROM VENDAS_ANALITICAS A
 JOIN PRODUTOS P ON A.PRODUTO = P. PRODUTO 
 JOIN FAMILIAS_PRODUTOS FP ON P.FAMILIA_PRODUTO = FP.FAMILIA_PRODUTO

 SELECT SUM (A.QUANTIDADE)
 , FP.DESCRICAO AS FAMILIA
 FROM VENDAS_ANALITICAS A
 JOIN PRODUTOS P ON A.PRODUTO = P. PRODUTO 
 JOIN FAMILIAS_PRODUTOS FP ON P.FAMILIA_PRODUTO = FP.FAMILIA_PRODUTO
 GROUP BY FP.DESCRICAO

 -- DESAFIO --
 /* RECUPERE O TOTAL VENDIDO POR MARCA DO PRODUTO SABENDO QUE 
 1. O TOTAL VENDIDO CORRESPONDE A COLUNA VENDA_LIQUIDA DA TABELA VENDAS_ANALITICAS
 2. A COLUNA PRODUTO FAZ RELA��O COM A TABELA DE PRODUTOS ATRAVES DA COLUNA PRODUTO
 * TENTE INDENTIFICAR AS DEMAIS RELA��ES NECESSARIAS
 * A SUA CONSULTA DEVERA EXIBIR AS SEGUINTES INFORMA�OES
 1. CODIGO DA MARCA 
 2. DESCRI��O DA MARCA
 3. TOTAL DA VENDA LIQUIDA
 * REALIZE A ORDERNA��O DO RESULTADO PELO CODICO DA MARCA 
 */
 
 SP_HELP PRODUTOS 

 SELECT P.MARCA AS CODIGO_DA_MARCA
 , M.DESCRICAO AS DESCRICAO_DA_MARCA
 , SUM(V.VENDA_LIQUIDA) AS TOTAL_DA_VENDA_LIQUIDA
 FROM VENDAS_ANALITICAS V
 JOIN PRODUTOS P ON V.PRODUTO = P.PRODUTO
 JOIN MARCAS M ON P.MARCA = M.MARCA
 GROUP BY P.MARCA, M.DESCRICAO
 ORDER BY P.MARCA

 --LEFT JOIN 

 SELECT P.PRODUTO
 , P.DESCRICAO
 , P.FAMILIA_PRODUTO
 , F.DESCRICAO
 FROM PRODUTOS P
LEFT JOIN FAMILIAS_PRODUTOS F ON P.FAMILIA_PRODUTO = F.FAMILIA_PRODUTO

 SELECT P.PRODUTO
 , P.DESCRICAO
 , P.FAMILIA_PRODUTO
 , COALESCE(F.DESCRICAO, 'N�O ENCONTRADA') AS DESCRI��O
 FROM PRODUTOS P
LEFT JOIN FAMILIAS_PRODUTOS F ON P.FAMILIA_PRODUTO = F.FAMILIA_PRODUTO

SELECT COUNT(*)
FROM PRODUTOS A
LEFT JOIN GRUPOS_PRODUTOS B ON A.GRUPO_PRODUTO = B.GRUPO_PRODUTO

 SELECT COALESCE (C.DESCRICAO, 'N�O ENCONTRADO') AS FAMILIA
 , SUM (A.QUANTIDADE)
  FROM VENDAS_ANALITICAS A
  JOIN PRODUTOS B ON A.PRODUTO = B.PRODUTO
LEFT JOIN FAMILIAS_PRODUTOS C ON B.FAMILIA_PRODUTO = C.FAMILIA_PRODUTO
GROUP BY C.DESCRICAO

--DESAFIO--
/* TABELA: VENDAS_ANALITICAS 
RECUPERE A QUANTIDADE DE PRODUTOS E A MEDIA DE VENDAS POR FABRICANTE DE ACORDO COM 
OS CRITERIOS ABAIXO

1. DEVE SER UTILIZADA A COLUNA VENDA_LIQUIDA PARA CALCULAR A M�DIA ARITMETICA 
2. O FABRICANTE EST� NA TABELA DE PRODUTOS
3. DEVEM SER EXIBIDAS DO RESULTADO DA CONSULTA E SEGUINTES COLUNAS

--> CODIGO DO FABRICANTE
--> NOME DO FABRICANTE 
--> QUANTIDADE DE PRODUTOS DISTINTOS CADASTRADOS PARA O FABRICANTE
--> MEDIA DE VENDAS DO FABRICANTE 

4. CASO O PRODUTO N�O TENHA FABRICANTE DEVE SER IFORMADO COM FABRICANTE N�O IDENTIFICADO
5. ORDENE PELO FABRICANTE QUE TEM A MELHOR MEDIA DE VENDAS
*/
SP_HELP VENDAS_ANALITICAS 

SELECT B.FABRICANTE AS COD_FABRICANTE
, COALESCE( C.NOME, 'N�O ENCONTRADO') NOME_FABRICANTE
, COUNT (DISTINCT A.PRODUTO) AS QUANTIDADE_PRODUTOS
, AVG(A.VENDA_LIQUIDA) AS MEDIA_VENDA
FROM PRODUTOS B
LEFT JOIN VENDAS_ANALITICAS A ON A.PRODUTO = B.PRODUTO
LEFT JOIN PESSOAS_JURIDICAS C ON B.FABRICANTE = C.ENTIDADE
GROUP BY B.FABRICANTE, C.NOME
ORDER BY MEDIA_VENDA DESC
