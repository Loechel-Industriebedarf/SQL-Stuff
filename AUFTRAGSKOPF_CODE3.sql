USE [LOE01]
GO
/****** Object:  Trigger [dbo].[AUFTRAGSKOPF_CODE3]    Script Date: 14.03.2025 09:01:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER TRIGGER [dbo].[AUFTRAGSKOPF_CODE3]
   ON  [dbo].[AUFTRAGSKOPF]
   AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;
	DECLARE @CodeAlt varchar(200)
	DECLARE @CodeNeu varchar(100)
	DECLARE @Beleg decimal(15, 0)
	DECLARE @Belegart varchar(4)
	DECLARE @EmailInvoice varchar(2000)
	DECLARE @Kundennr decimal(15, 0)

	SELECT @CodeAlt = INSERTED.CODE3
		FROM INSERTED
	SELECT @CodeNeu = INSERTED.CODE1
		FROM INSERTED
	Select @Beleg = INSERTED.BELEGNR
		FROM INSERTED
	Select @Belegart = INSERTED.BELEGART
		FROM INSERTED
	SELECT @Kundennr = INSERTED.KUNDENNR 
		FROM INSERTED
	SELECT @EmailInvoice = EmailInvoice 
		FROM dbo.AUFTRAGSKOPF INNER JOIN dbo.KUNDEN ON dbo.KUNDEN.KUNDENNR = dbo.AUFTRAGSKOPF.KUNDENNR WHERE dbo.AUFTRAGSKOPF.KUNDENNR = @Kundennr

	-- If the mail was already set, don't do it again. 
	-- Don't set if the customer has an invoice email
	IF @CodeNeu LIKE '%@%' AND (@CodeAlt LIKE '' OR @CodeAlt is null) AND @EmailInvoice is null
			UPDATE [dbo].[AUFTRAGSKOPF] SET CODE3 = @CodeNeu WHERE BELEGNR = @Beleg
END
