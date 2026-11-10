USE LOE01;
go

SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
go

	update dbo.artikel 
	SET [KEININTERNET] = 1, 
	[P116LI_NoEcommerce5] = 1, 
	[P116LI_NoEcommerce6] = 1, 
	[P116LI_NoEcommerce7] = 1, 
	[P116LI_NoEcommerce8] = 1, 
	[SACHBEARBEITERNR] = 'ADMIN', 
	AENDERUNGSDATUM = GETDATE(),
	[MEMO] = Concat([MEMO], ' ', FORMAT(getdate(), 'dd.MM.yyyy'), ' - ', 'ADMIN: Alle Haken gesetzt, weil  illegaler Begriff im Artikeltext (z.B. Biozid).')
	from dbo.artikel
	inner join dbo.artikeltext on dbo.artikel.artikelnr = dbo.artikeltext.artikelnr
	where 
	(text like '%biozid%' or dbo.artikel.BEZEICHNUNG like '%biozid%') 
	and memo not like '%biozid%'
go