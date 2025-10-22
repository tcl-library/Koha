SELECT
    item_homebranch,
    SUM(CASE WHEN age_category = 'Juvenile' THEN 1 ELSE 0 END) AS Juvenile,
    SUM(CASE WHEN age_category = 'Young Adult' THEN 1 ELSE 0 END) AS "Young Adult",
    SUM(CASE WHEN age_category = 'Adult' THEN 1 ELSE 0 END) AS Adult,
    COUNT(*) AS Total
FROM (
    SELECT 
        COALESCE(items.homebranch, deleteditems.homebranch) AS item_homebranch,
        CASE
            WHEN statistics.location IN ('BOARDBOOK','EASYNONFIC','EASYREADER','JAV','JFICTION','JGRAPHIC',
                                         'JUVHOLIDAY','JUVMAG','JUVMANGA','JUVMUSIC','JNONFIC','JNONFICAV',
                                         'JSPANISH','JFSPANISH','PICTUREBK') THEN 'Juvenile'
            WHEN statistics.location IN ('YAGRAPHIC','YAFIC','YAFICAV','YAMAGAZ','YAMANGA','YANF','YAFICSPAN') THEN 'Young Adult'
            ELSE 'Adult'
        END AS age_category
    FROM statistics
    LEFT JOIN items ON statistics.itemnumber = items.itemnumber
    LEFT JOIN deleteditems ON statistics.itemnumber = deleteditems.itemnumber
    WHERE statistics.type = 'issue'
      AND COALESCE(items.homebranch, deleteditems.homebranch) LIKE 'TILL%'
      AND statistics.datetime >= CONCAT(<<Enter Fiscal Year (e.g., 2025)>> - 1, '-07-01')
      AND statistics.datetime < CONCAT(<<Enter Fiscal Year (e.g., 2025)>>, '-07-01')
) AS categorized_data
GROUP BY item_homebranch
ORDER BY item_homebranch