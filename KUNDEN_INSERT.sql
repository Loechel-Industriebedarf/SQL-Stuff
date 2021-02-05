USE [LOE01]
GO
/****** Object:  Trigger [dbo].[KUNDEN_INSERT]    Script Date: 05.02.2021 12:21:44 ******/
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
	DECLARE @PrivKunde smallint
	DECLARE @LKZ varchar(4)
	DECLARE @Land varchar(40)
	DECLARE @Ust varchar(40)
	DECLARE @VA smallint

	SELECT @Kundennr = INSERTED.KUNDENNR       
       FROM INSERTED

	SELECT @Kundengruppe = INSERTED.GRUPPE       
       FROM INSERTED

	SELECT @Zahlungsnr = INSERTED.ZBNUMMER
	   FROM INSERTED

	SELECT @PrivKunde = INSERTED.PRIVATKUNDE
	   FROM INSERTED

	SELECT @LKZ = INSERTED.LAENDERKZ
	   FROM INSERTED

	SELECT @Land = INSERTED.LAND
	   FROM INSERTED

	SELECT @Ust = INSERTED.IDENTNUMMER
	   FROM INSERTED

	 SELECT @VA = INSERTED.VANUMMER
	   FROM INSERTED

	   /* Wenn die Kundengruppe NW-Shop ist, Gesamtsperre aufheben */
	   /* Weiters wird der Kunde auf "Komplettliefern" gesetzt */
	   IF @Kundengruppe = '400'
	   BEGIN
			UPDATE [dbo].[KUNDEN] SET SPERRUNG = 0, CompleteDeliveryType = 1, NVH_PrintDeliveryDate = 2 WHERE KUNDENNR = @Kundennr
		END

		/* Wenn die Versandnummer leer ist, Versandnummer auf DHL/DPD setzen */
		IF @VA IS NULL
			UPDATE [dbo].[KUNDEN] SET VANUMMER = 18 WHERE KUNDENNR = @Kundennr

		/* Wenn die Zahlungsnummer leer ist, Zahlungsnummer auf Vorauszahlung setzen */
		IF @Zahlungsnr IS NULL
			UPDATE [dbo].[KUNDEN] SET ZBNUMMER = 10 WHERE KUNDENNR = @Kundennr

		/* Privatkunde entfernen */
		IF @PrivKunde = '1'
			UPDATE[dbo].[KUNDEN] SET PRIVATKUNDE = 0 WHERE KUNDENNR = @Kundennr

		/* Steuern ändern */
		If (@LKZ = 'AT' OR @Land = 'Österreich')
			If (@Ust = '' OR  @Ust is null)
				UPDATE[dbo].[KUNDEN] SET MWSTKZ = 3 WHERE KUNDENNR = @Kundennr
			Else
				UPDATE[dbo].[KUNDEN] SET MWSTKZ = 0 WHERE KUNDENNR = @Kundennr
END