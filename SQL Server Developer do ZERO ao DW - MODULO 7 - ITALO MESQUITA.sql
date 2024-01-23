use PBS_PROCFIT_DADOS
-- MODULO 07 -- 
SELECT A.ENTIDADE
, B.NOME
, SUM(A.VALOR_RECEBER) AS VALOR_RECEBER
, SUM(A.VALOR_PAGAR) AS VALOR_PAGAR 
, SUM(A.VALOR_RECEBER) - SUM(A.VALOR_PAGAR) AS SALDO
FROM(
		SELECT ENTIDADE, SUM(VALOR) AS VALOR_RECEBER, 0.00 AS VALOR_PAGAR
		FROM TITULOS_RECEBER
		GROUP BY ENTIDADE

		UNION ALL

		SELECT ENTIDADE, 0.00 AS VALOR_RECEBER, SUM(VALOR) AS VALOR_PAGAR
		FROM TITULOS_PAGAR
		GROUP BY ENTIDADE

) A
JOIN ENTIDADES B ON A.ENTIDADE = B.ENTIDADE

GROUP BY A.ENTIDADE, B.NOME
ORDER BY ENTIDADE