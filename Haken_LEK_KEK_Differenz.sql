USE LOE01
go

-- Alle Haken setzen wenn KEK doppelt so groß (oder größer) als LEK oder umgekehrt
UPDATE dbo.ARTIKEL SET [KEININTERNET] =1, [P116LI_NoEcommerce5] = 1, [P116LI_NoEcommerce6] = 1, [P116LI_NoEcommerce7] = 1, [P116LI_NoEcommerce8] = 1, [SACHBEARBEITERNR] = 'ADMIN', AENDERUNGSDATUM = getdate(), [MEMO] = Concat([MEMO], ' ', FORMAT(getdate(), 'dd.MM.yyyy'), ' - ', 'ADMIN: Alle Haken gesetzt, weil große Differenz zwischen KEK und LEK.') WHERE (KEK > LEK*2 OR LEK > KEK*2) AND (KEININTERNET = 0 OR KEININTERNET is null)

go