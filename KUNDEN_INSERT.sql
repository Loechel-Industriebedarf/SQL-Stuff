USE [LOE01]
GO
/****** Object:  Trigger [dbo].[KUNDEN_INSERT]    Script Date: 30.07.2018 10:07:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER TRIGGER [dbo].[KUNDEN_INSERT]
       ON [dbo].[KUNDEN]
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
	DECLARE @Kundennr decimal(15, 0)
	DECLARE @Kundengruppe varchar(8)
	DECLARE @Zahlungsnr smallint

	SELECT @Kundennr = INSERTED.KUNDENNR       
       FROM INSERTED

	SELECT @Kundengruppe = INSERTED.GRUPPE       
       FROM INSERTED

	SELECT @Zahlungsnr = INSERTED.ZBNUMMER
	   FROM INSERTED

	   /* Wenn die Kundengruppe NW-Shop ist, Gesamtsperre aufheben */
	   IF @Kundengruppe = '400'
			UPDATE [dbo].[KUNDEN] SET SPERRUNG = 0 WHERE KUNDENNR = @Kundennr

		/* Wenn die Zahlungsnummer leer ist, Zahlungsnummer auf Vorkasse setzen */
		IF @Zahlungsnr IS NULL
			UPDATE [dbo].[KUNDEN] SET ZBNUMMER = 10 WHERE KUNDENNR = @Kundennr
END