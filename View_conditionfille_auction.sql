SELECT        TOP (100) PERCENT 
	dbo.ARTIKEL.ARTIKELNR AS SUPPLIER_AID,
	
	-- Shipping time:
	-- When stock is greater than 0, set time to 2 (determined via KALKBASIS JOB)
	-- When shipping time is not set, set it to 10
	CASE WHEN  KALKBASIS = 0 THEN 2 WHEN dbo.artikel.numfeld1 IS NULL THEN 10 ELSE CAST(dbo.artikel.numfeld1 AS INT) END AS DELIVERY_TIME, 
	-- Use HoleSpacing as EAN, if EAN is not filled					 
	CASE WHEN dbo.artikel.ean IS NULL THEN dbo.artikel.p116li_holespacing ELSE ean END AS EAN, 
	-- Get first amount = 1*MENGEV or SWORDLENGTH
	CASE WHEN dbo.artikel.p116li_swordlength IS NULL THEN CONVERT(DECIMAL(10, 0), 1 * CASE WHEN dbo.artikel.mengev IS NOT NULL THEN dbo.artikel.mengev ELSE 1 END) ELSE CONVERT(DECIMAL(10, 0), 1 * dbo.artikel.p116li_swordlength) END AS LOWER_BOUND1, 
	-- +2 cents to fix low cost articles
	CONVERT(DECIMAL(10,2), dbo.ARTIKEL.VK3 * 1.03 + 0.02) AS NET_CUSTOMER1,                     
						 
	CONVERT(DECIMAL(10,2), dbo.ARTIKEL.KEK * 1.05 + 0.02) AS NET_LIST1, 
	-- Get second amount = 2*MENGEV or 2*SWORDLENGTH
	CASE WHEN dbo.artikel.p116li_swordlength IS NULL THEN CONVERT(DECIMAL(10, 0), 2 * CASE WHEN dbo.artikel.mengev IS NOT NULL THEN dbo.artikel.mengev ELSE 1 END) ELSE CONVERT(DECIMAL(10, 0), 2 * dbo.artikel.p116li_swordlength) END AS LOWER_BOUND2, 
	
    CONVERT(DECIMAL(10,2), dbo.ARTIKEL.VK3 * 1.015 + 0.01) AS NET_CUSTOMER2, 
	
    CONVERT(DECIMAL(10,2), dbo.ARTIKEL.KEK * 1.04 + 0.01) AS NET_LIST2, 
	-- Get second amount = 5*MENGEV or 5*SWORDLENGTH
	CASE WHEN dbo.artikel.p116li_swordlength IS NULL THEN CONVERT(DECIMAL(10, 0), 5 * CASE WHEN dbo.artikel.mengev IS NOT NULL THEN dbo.artikel.mengev ELSE 1 END) ELSE CONVERT(DECIMAL(10, 0), 5 * dbo.artikel.p116li_swordlength) END AS LOWER_BOUND3, 
	
    CONVERT(DECIMAL(10,2), dbo.ARTIKEL.VK3) AS NET_CUSTOMER3, 
    
	CONVERT(DECIMAL(10,2), dbo.ARTIKEL.KEK * 1.03) AS NET_LIST3
FROM            
	dbo.ARTIKEL 
	LEFT OUTER JOIN dbo.SONDERPREIS ON dbo.ARTIKEL.ARTIKELNR = dbo.SONDERPREIS.ARTIKELNR
WHERE        
	(dbo.ARTIKEL.GRUPPE <> 'A001') 
	AND (dbo.ARTIKEL.NoParcelService IS NULL OR dbo.ARTIKEL.NoParcelService = 0) 
	AND (dbo.ARTIKEL.STATUS = 1) 
	AND (dbo.ARTIKEL.KEININTERNET IS NULL OR dbo.ARTIKEL.KEININTERNET = 0) 
	AND (dbo.ARTIKEL.VK3 > 0) 
	AND (dbo.SONDERPREIS.PREIS IS NULL) 