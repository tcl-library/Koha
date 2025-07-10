SELECT
    items.homebranch,
    DATE_FORMAT(items.dateaccessioned, '%Y-%m') AS month_added,
    COUNT(*) AS items_added
FROM
    items
WHERE
    items.homebranch LIKE 'TILL%'
    AND items.dateaccessioned BETWEEN '2024-07-01' AND '2025-06-30'
    AND items.itype IN (
        'ATLAS','BOOK','BKCLUBKIT','KIT','LRGPRINT','LUCKYDAY','MAGAZINE','MAP',
        'TMNEWBOOK','NEWBOOK','TMNEWLRGPT','TMNEWMUSIC','NEWSPAPER','PAMPHLET',
        'READALONG','REFBOOK','STAFFBOOK','JBIGBOOK','TEXTBOOK'
    )
GROUP BY
    items.homebranch,
    month_added
ORDER BY
    items.homebranch,
    month_added