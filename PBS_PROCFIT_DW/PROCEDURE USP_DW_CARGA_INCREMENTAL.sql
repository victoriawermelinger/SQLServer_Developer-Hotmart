USE [PBS_PROCFIT_DW]
GO
/****** Object:  StoredProcedure [dbo].[USP_DW_CARGA_FULL]    Script Date: 28/03/2024 17:28:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_DW_CARGA_INCREMENTAL]
AS
--EXEC USP_FULL_D_CLIENTE

--EXEC USP_FULL_D_EMPRESA

--EXEC USP_FULL_D_PRODUTO

--EXEC USP_FULL_D_VENDEDORES

EXEC USP_CARGA_F_VENDAS 1