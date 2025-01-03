-- ================================================
-- Template generated from Template Explorer using:
-- Create Trigger (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- See additional Create Trigger templates for more
-- examples of different Trigger statements.
--
-- This block of comments will not be included in
-- the definition of the function.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE TRIGGER [dbo].[AUFTRAGSKOPF_BESTELLART] 
   ON [dbo].[AUFTRAGSKOPF] AFTER INSERT
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @Beleg decimal(15, 0)
	DECLARE @Auftragsart varchar(4)

    -- Insert statements for trigger here
	SELECT @Auftragsart = INSERTED.BELEGART
		FROM INSERTED

	IF @Auftragsart = '16'
		UPDATE [dbo].[AUFTRAGSKOPF] SET BESTELLART = 'online' WHERE BELEGNR = @Beleg
END
GO
