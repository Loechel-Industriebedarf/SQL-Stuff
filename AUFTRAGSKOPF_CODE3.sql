USE [LOE01]
GO
/****** Object:  Trigger [dbo].[AUFTRAGSKOPF_CODE3]    Script Date: 05.05.2021 09:13:18 ******/
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

	SELECT @CodeAlt = INSERTED.CODE3
		FROM INSERTED
	SELECT @CodeNeu = INSERTED.CODE1
		FROM INSERTED
	Select @Beleg = INSERTED.BELEGNR
		FROM INSERTED
	Select @Belegart = INSERTED.BELEGART
		FROM INSERTED

	-- If the mail was already set, don't do it again. If customer is from Amazon, don't set mail.
	IF @CodeNeu LIKE '%@%' AND (@CodeAlt LIKE '' OR @CodeAlt is null)
			UPDATE [dbo].[AUFTRAGSKOPF] SET CODE3 = @CodeNeu WHERE BELEGNR = @Beleg
END
