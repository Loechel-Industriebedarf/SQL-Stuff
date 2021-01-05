SELECT DISTINCT TOP 100 ARTIKEL.ARTIKELNR, 

-- Load everything into one line
STUFF(
	(SELECT 
		-- FeatureName|FeatureValue$FeaturName2|FeatureValue2
		'$' + MerkmalsName + '|' + MerkmalsWert
		FROM view_MERKMALE
		-- Only show values for one article
		WHERE Artikelnummer = ARTIKEL.ARTIKELNR
		FOR XML PATH(''))
	,1,1,''
) as MerkmalsListe

from ARTIKEL

INNER JOIN view_MERKMALE ON view_MERKMALE.Artikelnummer = ARTIKEL.ARTIKELNR 
