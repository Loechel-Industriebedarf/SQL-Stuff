-- Select all articles
SELECT TOP (100) PERCENT 
	dbo.ARTIKEL.ARTIKELNR AS SUPPLIER_AID, 
	-- Shipping time:
	-- When stock is greater than 0, set time to 2
	-- When shipping time is not set, set it to 10
	CASE WHEN dbo.LAGER.BUCHBESTAND > 0 THEN 2 WHEN dbo.ARTIKEL.NUMFELD1 IS NULL THEN 10 ELSE CAST(dbo.ARTIKEL.NUMFELD1 AS INT) END AS DELIVERY_TIME, 
	-- Use HoleSpacing as EAN, if EAN is not filled
	CASE WHEN dbo.ARTIKEL.EAN IS NULL THEN dbo.ARTIKEL.P116LI_HoleSpacing ELSE EAN END AS EAN, 
	
		-- Auction prices are only calculated, if we make more than 5% profit
	
		-- Get first amount = 1
		CONVERT(DECIMAL(10, 0), 1 * CASE WHEN dbo.ARTIKEL.MENGEV IS NOT NULL THEN dbo.ARTIKEL.MENGEV ELSE 1 END) AS LOWER_BOUND1,
			-- Get first price = VK3
			dbo.ARTIKEL.VK3 AS NET_CUSTOMER1, 
				-- Get first auction price = 99%
				CASE WHEN dbo.ARTIKEL.VK3 * 0.95 > dbo.ARTIKEL.KEK OR dbo.ARTIKEL.VK3 * 0.95 > dbo.ARTIKEL.LEK THEN CONVERT(DECIMAL(10, 2), dbo.ARTIKEL.VK3 * 0.99) ELSE VK3 END AS NET_LIST1, 
	
		-- Get second amount = 2
		CONVERT(DECIMAL(10, 0), 2 * CASE WHEN dbo.ARTIKEL.MENGEV IS NOT NULL THEN dbo.ARTIKEL.MENGEV ELSE 1 END) AS LOWER_BOUND2, 
			-- Get second price = 99.5%
			CASE WHEN dbo.ARTIKEL.VK3 * 0.95 > dbo.ARTIKEL.KEK OR dbo.ARTIKEL.VK3 * 0.95 > dbo.ARTIKEL.LEK THEN CONVERT(DECIMAL(10, 2), dbo.ARTIKEL.VK3 * 0.995) ELSE dbo.ARTIKEL.VK3 END AS NET_CUSTOMER2, 
				-- Get second auction price = 98.5%
				CASE WHEN dbo.ARTIKEL.VK3 * 0.95 > dbo.ARTIKEL.KEK OR dbo.ARTIKEL.VK3 * 0.95 > dbo.ARTIKEL.LEK THEN CONVERT(DECIMAL(10, 2), dbo.ARTIKEL.VK3 * 0.985) ELSE dbo.ARTIKEL.VK3 END AS NET_LIST2, 
	
		-- Get third amount = 5
		CONVERT(DECIMAL(10, 0), 5 * CASE WHEN dbo.ARTIKEL.MENGEV IS NOT NULL THEN dbo.ARTIKEL.MENGEV ELSE 1 END) AS LOWER_BOUND3, 
			-- Get third price = 99%
			CASE WHEN dbo.ARTIKEL.VK3 * 0.95 > dbo.ARTIKEL.KEK OR dbo.ARTIKEL.VK3 * 0.95 > dbo.ARTIKEL.LEK THEN CONVERT(DECIMAL(10, 2), dbo.ARTIKEL.VK3 * 0.99) ELSE dbo.ARTIKEL.VK3 END AS NET_CUSTOMER3, 
				-- Get third auction price = 98%
				CASE WHEN dbo.ARTIKEL.VK3 * 0.95 > dbo.ARTIKEL.KEK OR dbo.ARTIKEL.VK3 * 0.95 > dbo.ARTIKEL.LEK THEN CONVERT(DECIMAL(10, 2), dbo.ARTIKEL.VK3 * 0.98) ELSE dbo.ARTIKEL.VK3 END AS NET_LIST3
							
FROM dbo.ARTIKEL LEFT OUTER JOIN
	dbo.LAGER ON dbo.ARTIKEL.ARTIKELNR = dbo.LAGER.ARTIKELNR 
LEFT OUTER JOIN
    dbo.SONDERPREIS ON dbo.ARTIKEL.ARTIKELNR = dbo.SONDERPREIS.ARTIKELNR
WHERE        
	-- No PV
	(dbo.ARTIKEL.GRUPPE <> 'A001') 
	-- Only parcel service
	AND (dbo.ARTIKEL.NoParcelService IS NULL OR dbo.ARTIKEL.NoParcelService = 0) 
	-- Only status 1
	AND (dbo.ARTIKEL.STATUS = 1) 
	-- Only products, that should be sold online
	AND (dbo.ARTIKEL.KEININTERNET IS NULL OR dbo.ARTIKEL.KEININTERNET = 0) 
	-- Only products with a price
	AND (dbo.ARTIKEL.VK3 > 0) 
	-- No products with a special price
	AND (dbo.SONDERPREIS.PREIS IS NULL)
	-- Only storage 1
	AND (dbo.LAGER.LAGERNR = 1)