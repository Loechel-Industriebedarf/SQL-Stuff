WITH cte AS (SELECT        TOP (2147483647) dbo.PREISGRUPPEN.ARTIKELNR, dbo.ARTIKEL.KEK, dbo.ARTIKEL.LEK, dbo.PREISGRUPPEN.PREIS, dbo.PREISGRUPPEN.ROWID
                             FROM            dbo.PREISGRUPPEN INNER JOIN
                                                      dbo.ARTIKEL ON dbo.PREISGRUPPEN.ARTIKELNR = dbo.ARTIKEL.ARTIKELNR
                             WHERE        (dbo.PREISGRUPPEN.GRUPPE = 5)
                             ORDER BY dbo.PREISGRUPPEN.ARTIKELNR, dbo.PREISGRUPPEN.ROWID DESC)
    SELECT        cte_2.ARTIKELNR, cte_2.PREIS AS VK5
     FROM            cte AS cte_2 INNER JOIN
                                  (SELECT        ARTIKELNR, MAX(ROWID) AS ROWID
                                    FROM            cte AS cte_1
                                    GROUP BY ARTIKELNR) AS A ON cte_2.ARTIKELNR = A.ARTIKELNR AND cte_2.ROWID = A.ROWID