-- Select all articles
-- cte.CALC -> Price calculation for the article
SELECT TOP (2147483647) 
	dbo.View_VK5Preise.ARTIKELNR, 
	-- Rounds last digit after comma to 9
	ABS(CAST(cte.KEKLEK * cte.CALC as decimal(18,1))) + 0.09 AS VK5Neu, 
	dbo.View_VK5Preise.VK5 AS VK5Alt, 
	cte.KEKLEK, 
	dbo.ARTIKEL.KEK, 
	dbo.ARTIKEL.LEK, 
	dbo.ARTIKEL.VK1, 
	dbo.ARTIKEL.KALKBASIS, 
	cte.CALC, 
	dbo.ARTIKEL.MENGEV, 
	dbo.ARTIKEL.VKPRO,
	dbo.View_VK5Preise.CLERKID,
	dbo.ARTIKEL.P53_SpecialPriceMemo
-- VK5Preise is another view, that just reads the current VK5 prices
FROM 
	dbo.View_VK5Preise 

INNER JOIN
    dbo.ARTIKEL ON dbo.View_VK5Preise.ARTIKELNR = dbo.ARTIKEL.ARTIKELNR 
INNER JOIN
	(SELECT TOP (2147483647) 
		ARTIKELNR, 
		CASE WHEN ARTIKEL_1.P116LI_TeethCount LIKE '%-%' THEN
			VK1 
		ELSE
			CASE WHEN KALKBASIS = 2 THEN KEK 
				-- If LEK is 0, use KEK instead
			ELSE 
				CASE WHEN LEK = 0 THEN KEK
				ELSE LEK END
			END 
		END
		AS KEKLEK, 
		
		-- If P116LI_TeethCount exists, use its value
		-- If it does not exist, use a diffent logic
		CASE WHEN (ARTIKEL_1.P116LI_TeethCount IS NOT NULL) THEN 
			CAST(REPLACE(ARTIKEL_1.P116LI_TeethCount, ',', '.') AS float) 
		ELSE
			CASE WHEN ARTIKEL_1.MENGEV IS NOT NULL OR ARTIKEL_1.VKPRO > 1
				THEN 1.06
			ELSE
				CASE WHEN ARTIKEL_1.KEK > 200 
					THEN 1.06 
				ELSE 
					CASE WHEN ARTIKEL_1.KEK > 100 
						THEN 1.09 
					ELSE 
						CASE WHEN ARTIKEL_1.KEK > 50 
							THEN 1.11 
						ELSE 1.16 
						END 
					END 
				END 
			END
		END 
		AS CALC
	FROM dbo.ARTIKEL AS ARTIKEL_1) AS cte ON dbo.View_VK5Preise.ARTIKELNR = cte.ARTIKELNR 
	-- Filter articles with less than 1 cent difference
	AND 
		(ABS(CAST(cte.KEKLEK * cte.CALC as decimal(18,1))) + 0.09 < dbo.View_VK5Preise.VK5 - 0.01 OR 
		ABS(CAST(cte.KEKLEK * cte.CALC as decimal(18,1))) + 0.09 > dbo.View_VK5Preise.VK5 + 0.01) 
	-- Filter articles with specialpricememo, when the price is high enought
	AND (dbo.ARTIKEL.P53_SpecialPriceMemo IS NULL OR cte.KEKLEK > dbo.View_VK5Preise.VK5)
	-- Don't change manually changed prices, when the price is high enought
	AND ((dbo.View_VK5Preise.CLERKID LIKE 'MRI' OR dbo.View_VK5Preise.CLERKID LIKE 'SEW' OR dbo.View_VK5Preise.CLERKID LIKE 'ADMIN' ) OR cte.KEKLEK > dbo.View_VK5Preise.VK5)
	-- Filter deleted articles
	AND (dbo.ARTIKEL.GELOESCHT IS NULL OR dbo.ARTIKEL.GELOESCHT = 0) 
	-- Filter articles with low KEK/LEK
	AND (cte.KEKLEK > 0.5)
	