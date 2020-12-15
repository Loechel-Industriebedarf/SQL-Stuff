-- Select all articles
-- cte.CALC -> Price calculation for the article
SELECT TOP (2147483647) 
	dbo.View_VK5Preise.ARTIKELNR, cte.KEKLEK * cte.CALC AS VK5Neu, dbo.View_VK5Preise.VK5 AS VK5Alt, cte.KEKLEK, dbo.ARTIKEL.KEK, dbo.ARTIKEL.LEK, dbo.ARTIKEL.KALKBASIS, cte.CALC, dbo.ARTIKEL.MENGEV, dbo.ARTIKEL.VKPRO
-- VK5Preise is another view, that just reads the current VK5 prices
FROM 
	dbo.View_VK5Preise 

INNER JOIN
    dbo.ARTIKEL ON dbo.View_VK5Preise.ARTIKELNR = dbo.ARTIKEL.ARTIKELNR 
INNER JOIN
	(SELECT TOP (2147483647) 
		ARTIKELNR, 
		CASE WHEN KALKBASIS = 2 THEN KEK ELSE LEK END AS KEKLEK, 
		-- If P116LI_TeethCount exists, use its value
		-- If it does not exist, use a diffent logic
		CASE WHEN (ARTIKEL_1.P116LI_TeethCount IS NOT NULL) THEN 
			CAST(REPLACE(ARTIKEL_1.P116LI_TeethCount, ',', '.') AS float) 
		ELSE
			CASE WHEN ARTIKEL_1.MENGEV IS NOT NULL OR ARTIKEL_1.VKPRO > 1
				THEN 1.05
			ELSE
				CASE WHEN ARTIKEL_1.KEK > 200 
					THEN 1.05 
				ELSE 
					CASE WHEN ARTIKEL_1.KEK > 100 
						THEN 1.08 
					ELSE 
						CASE WHEN ARTIKEL_1.KEK > 50 
							THEN 1.1 
						ELSE 1.15 
						END 
					END 
				END 
			END
		END 
		AS CALC
	FROM dbo.ARTIKEL AS ARTIKEL_1) AS cte ON dbo.View_VK5Preise.ARTIKELNR = cte.ARTIKELNR 
	-- Filter articles with less than 1 cent difference
	AND (cte.KEKLEK * cte.CALC < dbo.View_VK5Preise.VK5 - 0.01 OR cte.KEKLEK * cte.CALC > dbo.View_VK5Preise.VK5 + 0.01) 
	-- Filter articles with specialpricememo
	AND dbo.ARTIKEL.P53_SpecialPriceMemo IS NULL 
	-- Filter articles that should not be sold
	AND (dbo.ARTIKEL.P116LI_NoEcommerce5 IS NULL OR dbo.ARTIKEL.P116LI_NoEcommerce5 = 0) 
	-- Filter deleted articles
	AND (dbo.ARTIKEL.GELOESCHT IS NULL OR dbo.ARTIKEL.GELOESCHT = 0)