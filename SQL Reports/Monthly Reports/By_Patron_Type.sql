SELECT
    s.branch AS Branch,
    SUM(CASE WHEN p.categorycode = 'ADULT999' THEN 1 ELSE 0 END) AS `ADULT 999`,
    SUM(CASE WHEN p.categorycode = 'JUV999' THEN 1 ELSE 0 END) AS `JUV 999`,
    SUM(CASE WHEN p.categorycode = 'EDUCATOR' THEN 1 ELSE 0 END) AS `EDUCATOR`,
    SUM(CASE WHEN p.categorycode = 'TEMP90' THEN 1 ELSE 0 END) AS `TEMP 90`,
    SUM(CASE WHEN p.categorycode = 'TEMP-1YEAR' THEN 1 ELSE 0 END) AS `TEMP 1 YR`,
    SUM(CASE WHEN p.categorycode = 'PASSPORT' THEN 1 ELSE 0 END) AS `PASSPORT`,
    SUM(CASE WHEN p.categorycode = 'STAFF' THEN 1 ELSE 0 END) AS `STAFF`,
    SUM(CASE WHEN p.categorycode = 'ADULT' THEN 1 ELSE 0 END) AS `ADULT`,
    SUM(CASE WHEN p.categorycode = 'JUVENILE' THEN 1 ELSE 0 END) AS `JUVENILE`,
    SUM(CASE WHEN p.categorycode = 'TEMPORARY' THEN 1 ELSE 0 END) AS `TEMPORARY`,
    SUM(CASE WHEN p.categorycode = 'ILL_OUT' THEN 1 ELSE 0 END) AS `ILL OUT`,
    SUM(CASE WHEN p.categorycode = 'LCLD-ADULT' THEN 1 ELSE 0 END) AS `LCLD-ADULT`,
    SUM(CASE WHEN p.categorycode = 'TEMP90PAID' THEN 1 ELSE 0 END) AS `TEMP 90 PAID`,
    SUM(CASE WHEN p.categorycode = 'TEMP30' THEN 1 ELSE 0 END) AS `TEMP-30DAY`,
    SUM(CASE WHEN p.categorycode = 'TEMP-1YRPD' THEN 1 ELSE 0 END) AS `TEMP 1YR PAID`
FROM
    statistics s
    LEFT JOIN borrowers p USING (borrowernumber)
WHERE
    s.datetime BETWEEN <<Start Date|date>> AND <<End Date|date>>
    AND s.branch LIKE 'TILL%'
    AND s.type = 'issue'
GROUP BY
    s.branch
ORDER BY
    s.branch