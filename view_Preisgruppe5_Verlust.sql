SELECT        TOP (2147483647) dbo.View_VK5Preise.ARTIKELNR, cte.KEKLEK * cte.CALC AS VK5Neu, dbo.View_VK5Preise.VK5 AS VK5Alt, cte.KEKLEK, dbo.ARTIKEL.KEK, dbo.ARTIKEL.LEK, dbo.ARTIKEL.KALKBASIS, cte.CALC
FROM            dbo.View_VK5Preise INNER JOIN
                         dbo.ARTIKEL ON dbo.View_VK5Preise.ARTIKELNR = dbo.ARTIKEL.ARTIKELNR INNER JOIN
                             (SELECT        TOP (2147483647) ARTIKELNR, CASE WHEN KALKBASIS = 2 THEN KEK ELSE LEK END AS KEKLEK, CASE WHEN ARTIKEL_1.P116LI_RotationMin IS NOT NULL 
                                                         THEN CAST(REPLACE(ARTIKEL_1.P116LI_RotationMin, ',', '.') AS float) 
                                                         ELSE CASE WHEN ARTIKEL_1.KEK > 200 THEN 1.03 ELSE CASE WHEN ARTIKEL_1.KEK > 100 THEN 1.05 ELSE CASE WHEN ARTIKEL_1.KEK > 50 THEN 1.1 ELSE 1.15 END END END END AS CALC
                               FROM            dbo.ARTIKEL AS ARTIKEL_1) AS cte ON dbo.View_VK5Preise.ARTIKELNR = cte.ARTIKELNR AND (cte.KEKLEK * cte.CALC < dbo.View_VK5Preise.VK5 - 0.01 OR
                         cte.KEKLEK * cte.CALC > dbo.View_VK5Preise.VK5 + 0.01) AND dbo.ARTIKEL.P53_SpecialPriceMemo IS NULL AND (dbo.ARTIKEL.P116LI_NoEcommerce5 = 0 OR
                         dbo.ARTIKEL.P116LI_NoEcommerce5 IS NULL)