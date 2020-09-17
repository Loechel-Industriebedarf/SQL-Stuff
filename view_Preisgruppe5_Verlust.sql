SELECT        TOP (2147483647) dbo.View_VK5Preise.ARTIKELNR, cte.KEKLEK * cte.CALC AS VK5Neu, dbo.View_VK5Preise.VK5 AS VK5Alt, cte.KEKLEK, dbo.ARTIKEL.KEK, dbo.ARTIKEL.LEK, dbo.ARTIKEL.KALKBASIS, cte.CALC
FROM            dbo.View_VK5Preise INNER JOIN
                         dbo.ARTIKEL ON dbo.View_VK5Preise.ARTIKELNR = dbo.ARTIKEL.ARTIKELNR INNER JOIN
                             (SELECT        TOP (2147483647) ARTIKELNR, CASE WHEN KALKBASIS = 2 THEN KEK ELSE LEK END AS KEKLEK, CASE WHEN ARTIKEL_1.P116LI_RotationMin IS NULL 
                                                         THEN 1.15 ELSE CAST(REPLACE(ARTIKEL_1.P116LI_RotationMin, ',', '.') AS float) END AS CALC
                               FROM            dbo.ARTIKEL AS ARTIKEL_1) AS cte ON dbo.View_VK5Preise.ARTIKELNR = cte.ARTIKELNR AND cte.KEKLEK * cte.CALC > dbo.View_VK5Preise.VK5 AND dbo.ARTIKEL.P53_SpecialPriceMemo IS NULL