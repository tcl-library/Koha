SELECT
    borrowers.branchcode AS home_library,
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
    JOIN borrowers ON statistics.borrowernumber = borrowers.borrowernumber
WHERE
    statistics.type = 'issues'
    AND borrowers.branchcode LIKE 'TILL%'
    AND statistics.datetime >= '2024-07-01'
    AND statistics.datetime < '2025-07-01'
GROUP BY
    borrowers.branchcode,
    age_category
ORDER BY
    borrowers.branchcode,
    age_category