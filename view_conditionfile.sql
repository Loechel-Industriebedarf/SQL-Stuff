SELECT        TOP (100) PERCENT 
	dbo.ARTIKEL.ARTIKELNR AS SUPPLIER_AID, 
	CASE WHEN dbo.LAGER.BUCHBESTAND > 0 THEN 2 WHEN dbo.ARTIKEL.NUMFELD1 IS NULL THEN 10 ELSE CAST(dbo.ARTIKEL.NUMFELD1 AS INT) END AS DELIVERY_TIME, 
	CASE WHEN dbo.ARTIKEL.EAN IS NULL THEN dbo.ARTIKEL.P116LI_HoleSpacing ELSE EAN END AS EAN, 
	
	1 AS LOWER_BOUND1, 
	dbo.ARTIKEL.VK3 AS NET_CUSTOMER1, 
    CASE WHEN dbo.ARTIKEL.VK3 * 0.97 > dbo.ARTIKEL.KEK THEN CONVERT(DECIMAL(10, 2), dbo.ARTIKEL.VK3 * 0.99) ELSE VK3 END AS NET_LIST1, 
	
	2 AS LOWER_BOUND2, 
    CASE WHEN dbo.ARTIKEL.VK3 * 0.97 > dbo.ARTIKEL.KEK THEN CONVERT(DECIMAL(10, 2), dbo.ARTIKEL.VK3 * 0.995) ELSE dbo.ARTIKEL.VK3 END AS NET_CUSTOMER2, 
    CASE WHEN dbo.ARTIKEL.VK3 * 0.97 > dbo.ARTIKEL.KEK THEN CONVERT(DECIMAL(10, 2), dbo.ARTIKEL.VK3 * 0.985) ELSE dbo.ARTIKEL.VK3 END AS NET_LIST2, 
	
	5 AS LOWER_BOUND3, 
    CASE WHEN dbo.ARTIKEL.VK3 * 0.97 > dbo.ARTIKEL.KEK THEN CONVERT(DECIMAL(10, 2), dbo.ARTIKEL.VK3 * 0.99) ELSE dbo.ARTIKEL.VK3 END AS NET_CUSTOMER3, 
    CASE WHEN dbo.ARTIKEL.VK3 * 0.97 > dbo.ARTIKEL.KEK THEN CONVERT(DECIMAL(10, 2), dbo.ARTIKEL.VK3 * 0.98) ELSE dbo.ARTIKEL.VK3 END AS NET_LIST3
FROM            
	dbo.ARTIKEL LEFT OUTER JOIN                     
	dbo.LAGER ON dbo.ARTIKEL.ARTIKELNR = dbo.LAGER.ARTIKELNR LEFT OUTER JOIN
    dbo.SONDERPREIS ON dbo.ARTIKEL.ARTIKELNR = dbo.SONDERPREIS.ARTIKELNR
WHERE        
	(dbo.ARTIKEL.GRUPPE <> 'A001') AND 
	(dbo.ARTIKEL.NoParcelService IS NULL OR dbo.ARTIKEL.NoParcelService = 0) AND (
	dbo.ARTIKEL.STATUS = 1) AND 
	(dbo.ARTIKEL.KEININTERNET IS NULL OR dbo.ARTIKEL.KEININTERNET = 0) AND 
	(dbo.ARTIKEL.VK3 > 0) AND 
	(dbo.SONDERPREIS.PREIS IS NULL)
	
	
	
