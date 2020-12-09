USE [LOE01]
GO
/****** Object:  Trigger [dbo].[ARTIKEL_LAGERORT]    Script Date: 20.10.2020 11:51:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER TRIGGER [dbo].[ARTIKEL_LAGERORT]
   ON  [dbo].[ARTIKEL]
   AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;
	DECLARE @Lagerort varchar(14)
	DECLARE @Artikelnummer varchar(30)

	SELECT @Lagerort = TRIM(SUBSTRING(INSERTED.P116LI_TempMax, 0, 9))
		FROM INSERTED
	SELECT @Artikelnummer = INSERTED.ARTIKELNR
		FROM INSERTED

	UPDATE [dbo].[LAGER] SET LAGERPLATZ = @Lagerort WHERE ARTIKELNR = @Artikelnummer
END