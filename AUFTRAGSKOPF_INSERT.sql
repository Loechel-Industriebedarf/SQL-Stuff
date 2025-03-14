USE [LOE01]
GO
/****** Object:  Trigger [dbo].[AUFTRAGSKOPF_INSERT]    Script Date: 14.03.2025 09:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER TRIGGER [dbo].[AUFTRAGSKOPF_INSERT]
   ON  [dbo].[AUFTRAGSKOPF]
   AFTER INSERT
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @VersandartAlt smallint
	DECLARE @Beleg decimal(15, 0)
	DECLARE @Auftragsart varchar(4)
	DECLARE @Bestellart varchar(20)
	DECLARE @RKontakt varchar(150)
	

	SELECT @VersandartAlt = INSERTED.VANUMMER FROM INSERTED
	SELECT @Beleg = INSERTED.BELEGNR FROM INSERTED
	SELECT @Auftragsart = INSERTED.BELEGART FROM INSERTED
	SELECT @Bestellart = INSERTED.BESTELLART FROM INSERTED
	SELECT @RKontakt = INSERTED.RKONTAKT FROM INSERTED
	

	IF @VersandartAlt = 3 AND @Auftragsart = '16'
		UPDATE [dbo].[AUFTRAGSKOPF] SET VANUMMER = 18 WHERE BELEGNR = @Beleg

	IF @Auftragsart = '16' AND (@Bestellart = '' OR @Bestellart is null)
		UPDATE [dbo].[AUFTRAGSKOPF] SET BESTELLART = 'online' WHERE BELEGNR = @Beleg

	-- Wenn im Partner Feld ein @ übermittelt wird: In KD-Referenz schreiben
	IF @RKontakt LIKE '%@%'
		UPDATE [dbo].[AUFTRAGSKOPF] SET CODE1 = @RKontakt, RKONTAKT = null WHERE BELEGNR = @Beleg
END
