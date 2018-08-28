SELECT        'loechel' AS [Katalog-ID], 'Löchel Industriebedarf' AS Katalogname, CASE WHEN dbo.ArticleCalcGroup.Name IS NULL THEN 'Weitere Produkte' ELSE dbo.ArticleCalcGroup.Name END AS [Katalogstruktur-Kunde], 
                         '' AS [ID-Katalogstrukturknoten-NW], dbo.ARTIKEL.ARTIKELNR AS Artikelnummer, '' AS Variantenkurzbezeichnung, '' AS Variantenlangbezeichnung, '' AS Variantenartikelnummer, '' AS Variantensortierung, 
                         '' AS [Sortierung in der Warengruppe], dbo.ARTIKEL.BEZEICHNUNG AS Artikelkurzbezeichnung, ARTIKELTEXT_1.TEXT AS Artikellangbeschreibung, '' AS Zusatzinformationen, CASE WHEN dbo.ARTIKEL.EAN IS NULL 
                         THEN dbo.ExternalArticleID.ArticleIDExternal ELSE EAN END AS EAN, dbo.ARTIKEL.PurchOrderNumber AS [Hersteller Artikelnummer], dbo.ARTIKEL.P116LI_Producer_Name AS [Hersteller Name], 
                         dbo.ARTIKEL.VK1 AS [Preis (kleinste VPE zzgl. MwSt)], '' AS MwSt, dbo.ARTIKEL.VKPRO AS PE, dbo.ARTIKEL.EINHEITVK AS ME, CASE WHEN dbo.Artikel.MENGEV > 1 THEN CAST(dbo.Artikel.MENGEV AS int) 
                         ELSE '1' END AS [kleinste VPE], '' AS Kalkulationsschluessel, CASE WHEN dbo.Artikel.NoParcelService = 1 THEN 'Versand|Spedition/Stückgut' ELSE '' END AS Artikelmerkmale, '' AS Stichworte, '' AS Artikelverweise, 
                         CASE WHEN dbo.Artikel.P116LI_Picturefile1 IS NULL THEN dbo.Artikel.P116LI_Picturefile4 ELSE dbo.Artikel.P116LI_Picturefile1 END AS Hauptbild, dbo.ARTIKEL.P116LI_Picturefile4 AS Herstellerlogo, 
                         dbo.ARTIKEL.P116LI_Picturefile2 AS Zusatzabbildungen, dbo.ARTIKEL.P116LI_Picturefile3 AS Piktogramme, dbo.ARTIKEL.P116LI_Documentfile1 AS Datenblätter, 'x' AS Artikelkennzeichen, 
                         CASE WHEN dbo.Artikel.P116LI_NoEcommerce5 IS NULL THEN '' ELSE 'x' END AS GGVS, dbo.ARTIKEL.ZOLLTARIFNRI AS Zolltarifnummer, dbo.ARTIKEL.URSPRUNGSLAND AS Ursprungsland, '' AS [Grundpreis Mengeneinheit], 
                         '' AS [Grundpreis Nettoinhalt], '' AS [Grundpreis Bruttoinhalt], CASE WHEN dbo.ARTIKEL.Status > 1 OR
                         dbo.ARTIKEL.P116LI_NoEcommerce5 = 1 THEN 'x' ELSE '' END AS [nicht shopfähiger Artikel], '' AS Sprache, '' AS [ECLASS Klassifizierung], '' AS [PCLASS Klassifizierung], '' AS [UNSPSC Klassifizierung], '' AS Löschkennzeichen,
                          '' AS [Löschkennzeichen (Katalog)], '' AS [Prüffeld-Intern]
FROM            dbo.ARTIKEL LEFT OUTER JOIN
                         dbo.ExternalArticleID ON dbo.ARTIKEL.FSROWID = dbo.ExternalArticleID.FSROWID LEFT OUTER JOIN
                         dbo.ARTIKELTEXT AS ARTIKELTEXT_1 ON dbo.ARTIKEL.ARTIKELNR = ARTIKELTEXT_1.ARTIKELNR LEFT OUTER JOIN
                         dbo.ArticleCalcGroup ON dbo.ARTIKEL.ArticleCalcGroupID = dbo.ArticleCalcGroup.ArticleCalcGroupID
WHERE        (ABS(DAY(dbo.ARTIKEL.AENDERUNGSDATUM) - DAY(CONVERT(date, CURRENT_TIMESTAMP))) < 7)