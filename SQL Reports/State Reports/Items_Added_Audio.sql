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
        'VINYL','BOOKTAPE','BOOKCD','BOOKMP3','MUSICCD','MUSICTAPE',
        'NEWBOOKCD','PLAYAWAY','TMNEWBKCD'
    )
GROUP BY
    items.homebranch,
    month_added
ORDER BY
    items.homebranch,
    month_added;
