SELECT
    items.homebranch,
    CASE
        WHEN statistics.itemtype IN ('ATLAS','BOOK','BKCLUBKIT','KIT','LRGPRINT','LUCKYDAY','MAGAZINE','MAP',
                                     'TMNEWBOOK','NEWBOOK','TMNEWLRGPT','TMNEWMUSIC','NEWSPAPER','PAMPHLET',
                                     'READALONG','REFBOOK','STAFFBOOK','JBIGBOOK','TEXTBOOK') THEN 'Printed Items'
        WHEN statistics.itemtype IN ('VINYL','BOOKTAPE','BOOKCD','BOOKMP3','MUSICCD','MUSICTAPE',
                                     'NEWBOOKCD','PLAYAWAY','TMNEWBKCD') THEN 'Audio'
        WHEN statistics.itemtype IN ('BLURAY','BLURAYDVD','DVD','TMNEWBLURY','TMNEWDVD','VIDEO') THEN 'Video'
        
    END AS material_category,
    COUNT(*) AS circulation_count
FROM
    statistics
    JOIN items ON statistics.itemnumber = items.itemnumber
WHERE
    statistics.type = 'issue'
    AND items.homebranch LIKE 'TILL%'
    AND statistics.datetime BETWEEN '2024-07-01' AND '2025-06-30'
    AND statistics.itemtype IN (
        'ATLAS','BOOK','BKCLUBKIT','KIT','LRGPRINT','LUCKYDAY','MAGAZINE','MAP','TMNEWBOOK','NEWBOOK',
        'TMNEWLRGPT','TMNEWMUSIC','NEWSPAPER','PAMPHLET','READALONG','REFBOOK','STAFFBOOK','JBIGBOOK','TEXTBOOK',
        'VINYL','BOOKTAPE','BOOKCD','BOOKMP3','MUSICCD','MUSICTAPE','NEWBOOKCD','PLAYAWAY','TMNEWBKCD',
        'BLURAY','BLURAYDVD','DVD','TMNEWBLURY','TMNEWDVD','VIDEO'
    )
GROUP BY
    items.homebranch,
    material_category
ORDER BY
    material_category,
    items.homebranch