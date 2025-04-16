SELECT 
    count(s.datetime) AS circs,
    b.biblionumber,
    b.title,
    b.author
FROM 
    statistics s
JOIN 
    items i ON (i.itemnumber=s.itemnumber)
LEFT JOIN 
    biblio b ON (b.biblionumber=i.biblionumber)
WHERE s.datetime BETWEEN <<Begin Date|date>> AND <<End Date|date>>
    AND s.itemnumber IS NOT NULL 
    AND s.type IN ('issue','renew') 
    AND i.homebranch IN ('TILLMAIN', 'TILLBAY', 'TILLGAR', 'TILLROCK', 'TILLMANZ', 'TILLPAC', 'TILLBKM', 'TILLOUT')
GROUP BY 
    b.biblionumber
ORDER BY 
    circs 
DESC 
LIMIT 100