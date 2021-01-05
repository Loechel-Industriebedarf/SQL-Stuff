SELECT        dbo.SMLZUORDNUNG.ARTIKELNR AS Artikelnummer, dbo.ARTIKEL.BEZEICHNUNG AS Artikelbezeichnung, dbo.SMLMERKMALE.BEZEICHNUNG AS MerkmalsName, dbo.FeatureValues.ValueChar AS MerkmalsWert
FROM            dbo.ARTIKEL INNER JOIN
                         dbo.SMLMERKMALE INNER JOIN
                         dbo.FeatureValues INNER JOIN
                         dbo.SMLZUORDNUNG ON dbo.FeatureValues.ValueID = dbo.SMLZUORDNUNG.ValueID ON dbo.SMLMERKMALE.MERKMALNR = dbo.SMLZUORDNUNG.MERKMALNR ON 
                         dbo.ARTIKEL.ARTIKELNR = dbo.SMLZUORDNUNG.ARTIKELNR