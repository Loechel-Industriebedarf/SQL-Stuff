USE [LOE01]
GO
/****** Object:  Trigger [dbo].[ARTIKEL_LAGERORT]    Script Date: 02.09.2021 08:55:25 ******/
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

	-- Erste 8 Zeichen auslesen
	-- + Zeichen entfernen
	-- Leerzeichen an Anfang und Ende entfernen
	SELECT @Lagerort = TRIM(REPLACE(SUBSTRING(INSERTED.P116LI_TempMax, 0, 9), '+', ''))
		FROM INSERTED
	SELECT @Artikelnummer = INSERTED.ARTIKELNR
		FROM INSERTED

	UPDATE [dbo].[LAGER] SET LAGERPLATZ = @Lagerort WHERE ARTIKELNR = @Artikelnummer
END
