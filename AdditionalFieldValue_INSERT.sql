USE [LOE01]
GO
/****** Object:  Trigger [dbo].[AdditionalFieldValue_INSERT]    Script Date: 04.07.2018 10:18:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER TRIGGER [dbo].[AdditionalFieldValue_INSERT]
       ON [dbo].[AdditionalFieldValue]
AFTER INSERT
AS
BEGIN
       SET NOCOUNT ON;
 
	/* DECLARE VARIABLES */
        DECLARE @Trackingnummer varchar(255)
	DECLARE @Logistiker varchar(255)
	DECLARE @Belgnummer varchar(255)
	DECLARE @TableIDAuftrag UNIQUEIDENTIFIER
 
	/* GET TRACKINGNUMBER */
        SELECT @Trackingnummer = INSERTED.ValueString       
        FROM INSERTED WHERE INSERTED.DefRowID = '{BCE33303-72C2-11E8-9EBF-000C29018628}'

	/* GET LOGISTIKER */
	SELECT @Logistiker = INSERTED.ValueString       
        FROM INSERTED WHERE INSERTED.DefRowID = '{E7C59F43-72C2-11E8-9EBF-000C29018628}'

	 /* GET BELEGNUMMER um auf dessen Basis die ROWID des Auftrags zu erhalten */
	 SELECT @Belgnummer = [dbo].[BESTELLKOPF].[AUFTRAGSNR]
	 FROM [dbo].[BESTELLKOPF], INSERTED
	 WHERE [dbo].[BESTELLKOPF].[FSROWID] = INSERTED.TableRowID

	  /* GET AUFTRAG-FSROWID */
	  SELECT @TableIDAuftrag = [dbo].[AUFTRAGSKOPF].[FSROWID]
	  FROM [dbo].[AUFTRAGSKOPF]
	  WHERE [dbo].[AUFTRAGSKOPF].[BELEGNR] = @Belgnummer
 
	  /* INSERT IF NOT NULL */
	  IF @Trackingnummer IS NOT NULL
		INSERT INTO [dbo].[AdditionalFieldValue] (DefRowID, TableRowID, ValueString)
		VALUES('{BEF38EDC-2DBF-11E8-949A-000C29018628}', @TableIDAuftrag, @Trackingnummer)
	  ELSE IF @Logistiker IS NOT NULL
		INSERT INTO [dbo].[AdditionalFieldValue] (DefRowID, TableRowID, ValueString)
		VALUES('{91B2ACAD-791A-11E8-BB51-000C29018628}', @TableIDAuftrag, @Logistiker)      

END
