CREATE FUNCTION FN_CAMEL_CASE (@TEXTO VARCHAR(4000))

RETURNS VARCHAR(4000)

AS

BEGIN 
	DECLARE @POSICAO		INT = 1
	DECLARE @CHAR			CHAR(1)
	DECLARE @CHAR_ANTERIOR  CHAR(1)
	DECLARE @NOME_FORMATADO VARCHAR(100) = LOWER(@TEXTO)

		WHILE @POSICAO <= LEN(@TEXTO)
BEGIN 
     SET @CHAR = SUBSTRING(@TEXTO, @POSICAO,1)
		SET @CHAR_ANTERIOR = CASE WHEN @POSICAO = 1 THEN ' '
							    ELSE SUBSTRING (@TEXTO, @POSICAO -1, 1)
							END
	 IF @CHAR_ANTERIOR IN('')
	 BEGIN
		SET @NOME_FORMATADO = STUFF(@NOME_FORMATADO, @POSICAO, 1, UPPER(@CHAR))
	 END
	 SET @POSICAO = @POSICAO + 1
END
	RETURN @NOME_FORMATADO 
END