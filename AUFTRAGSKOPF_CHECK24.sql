USE [LOE01]
GO
/****** Object:  Trigger [dbo].[AUFTRAGSKOPF_CHECK24]    Script Date: 21.02.2023 10:38:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER TRIGGER [dbo].[AUFTRAGSKOPF_CHECK24]
   ON  [dbo].[AUFTRAGSKOPF]
   AFTER UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	DECLARE @Beleg decimal(15, 0)
	DECLARE @Belegart varchar(4)

	Select @Beleg = INSERTED.BELEGNR
		FROM INSERTED
	Select @Belegart = INSERTED.BELEGART
		FROM INSERTED

	Declare @val Varchar(MAX); 

	select @val = 'Versanddienstleister: ' + ValueString from dbo.AUFTRAGSKOPF 
	INNER JOIN dbo.additionalfieldvalue ON dbo.AUFTRagskopf.FSROWID = TableRowID
	where BELEGART = '24' and BELEGNR = @Beleg and DefRowID = '{91B2ACAD-791A-11E8-BB51-000C29018628}'

	select @val = COALESCE(@val + '<br>Trackingnummer: ' + ValueString, ValueString) from dbo.AUFTRAGSKOPF 
	INNER JOIN dbo.additionalfieldvalue ON dbo.AUFTRagskopf.FSROWID = TableRowID
	where BELEGART = '24' and BELEGNR = @Beleg and DefRowID = '{BEF38EDC-2DBF-11E8-949A-000C29018628}'

	
	
	IF @Belegart = '24'
		UPDATE [dbo].[AUFTRAGSKOPF] SET ENDETEXT = @val WHERE BELEGNR = @Beleg
END
