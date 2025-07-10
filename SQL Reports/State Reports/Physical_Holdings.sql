SELECT
    items.homebranch,
    CASE
        WHEN items.itype IN ('ATLAS','BOOK','BKCLUBKIT','KIT','LRGPRINT','LUCKYDAY','MAGAZINE','MAP',
                             'TMNEWBOOK','NEWBOOK','TMNEWLRGPT','TMNEWMUSIC','NEWSPAPER','PAMPHLET',
                             'READALONG','REFBOOK','STAFFBOOK','JBIGBOOK','TEXTBOOK') THEN 'Printed Items'
        WHEN items.itype IN ('VINYL','BOOKTAPE','BOOKCD','BOOKMP3','MUSICCD','MUSICTAPE',
                             'NEWBOOKCD','PLAYAWAY','TMNEWBKCD') THEN 'Audio'
        WHEN items.itype IN ('BLURAY','BLURAYDVD','DVD','TMNEWBLURY','TMNEWDVD','VIDEO') THEN 'Video'
        ELSE 'Other'
    END AS material_category,
    COUNT(*) AS item_count
FROM
    items
WHERE
    items.homebranch LIKE 'TILL%'
    AND items.dateaccessioned <= '2025-06-30'
    AND items.itype IN (
        'ATLAS','BOOK','BKCLUBKIT','KIT','LRGPRINT','LUCKYDAY','MAGAZINE','MAP','TMNEWBOOK','NEWBOOK',
        'TMNEWLRGPT','TMNEWMUSIC','NEWSPAPER','PAMPHLET','READALONG','REFBOOK','STAFFBOOK','JBIGBOOK','TEXTBOOK',
        'VINYL','BOOKTAPE','BOOKCD','BOOKMP3','MUSICCD','MUSICTAPE','NEWBOOKCD','PLAYAWAY','TMNEWBKCD',
        'BLURAY','BLURAYDVD','DVD','TMNEWBLURY','TMNEWDVD','VIDEO'
    )
GROUP BY
    material_category,
    items.homebranch
ORDER BY
    material_category,
    items.homebranch