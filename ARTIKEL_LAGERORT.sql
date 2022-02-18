USE [LOE01]
GO
/****** Object:  Trigger [dbo].[ARTIKEL_LAGERORT]    Script Date: 18.02.2022 14:31:09 ******/
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
	-- Nach Leerzeichen abschneiden
	SELECT @Lagerort = TRIM(REPLACE(SUBSTRING(INSERTED.P116LI_TempMax, 0, 9), '+', ''))
		FROM INSERTED
	SELECT @Lagerort = LEFT(@Lagerort, CHARINDEX(' ', @Lagerort) - 1)  FROM INSERTED where CHARINDEX(' ', @Lagerort) > 0
	SELECT @Artikelnummer = INSERTED.ARTIKELNR
		FROM INSERTED

	UPDATE [dbo].[LAGER] SET LAGERPLATZ = @Lagerort WHERE ARTIKELNR = @Artikelnummer AND LAGERNR = 1
END
