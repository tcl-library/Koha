SELECT
    COALESCE(items.homebranch, deleteditems.homebranch) AS item_homebranch,
    CASE
        WHEN statistics.location IN ('BOARDBOOK','EASYNONFIC','EASYREADER','JAV','JFICTION','JGRAPHIC',
                                     'JUVHOLIDAY','JUVMAG','JUVMANGA','JUVMUSIC','JNONFIC','JNONFICAV',
                                     'JSPANISH','JFSPANISH','PICTUREBK') THEN 'Juvenile'
        WHEN statistics.location IN ('YAGRAPHIC','YAFIC','YAFICAV','YAMAGAZ','YAMANGA','YANF','YAFICSPAN') THEN 'Young Adult'
        ELSE 'Adult'
    END AS age_category,
    COUNT(*) AS checkouts
FROM
    statistics
    LEFT JOIN items ON statistics.itemnumber = items.itemnumber
    LEFT JOIN deleteditems ON statistics.itemnumber = deleteditems.itemnumber
WHERE
    statistics.type = 'issue'
    AND COALESCE(items.homebranch, deleteditems.homebranch) LIKE 'TILL%'
    AND statistics.datetime >= '2024-07-01'
    AND statistics.datetime < '2025-07-01'
GROUP BY
    item_homebranch,
    age_category
ORDER BY
    item_homebranch,
    age_category