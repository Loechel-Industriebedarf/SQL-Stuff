USE [LOE01]
GO
/****** Object:  Trigger [dbo].[AdditionalFieldValue_INSERT]    Script Date: 18.07.2018 10:35:41 ******/
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

	SELECT @Kundennr = INSERTED.KUNDENNR       
       FROM INSERTED

	SELECT @Kundengruppe = INSERTED.GRUPPE       
       FROM INSERTED

	   /* Wenn die Kundengruppe NW-Shop ist, Gesamtsperre aufheben */
	   IF @Kundengruppe = '400'
			UPDATE [dbo].[KUNDEN] SET SPERRUNG = 0 WHERE KUNDENNR = @Kundennr
END