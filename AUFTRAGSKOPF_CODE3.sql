USE [LOE01]
GO
/****** Object:  Trigger [dbo].[AUFTRAGSKOPF_CODE3]    Script Date: 09.04.2019 09:21:04 ******/
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
	DECLARE @CodeNeu varchar(40)
	DECLARE @Beleg decimal(15, 0)

	SELECT @CodeNeu = INSERTED.CODE1
		FROM INSERTED
	Select @Beleg = INSERTED.BELEGNR
		FROM INSERTED

	IF @CodeNeu LIKE '%@%'
			UPDATE [dbo].[AUFTRAGSKOPF] SET CODE3 = @CodeNeu WHERE BELEGNR = @Beleg
END
