SELECT 
    branches.branchname AS Branch,
    itemtypes.description AS Item_Type,
    COUNT(*) AS Total_Circulations
FROM 
    statistics
JOIN 
    items ON statistics.itemnumber = items.itemnumber
JOIN 
    branches ON statistics.branch = branches.branchcode
JOIN 
    itemtypes ON items.itype = itemtypes.itemtype
WHERE 
    items.location = 'ASKATDESK'
    AND statistics.branch IN ('TILLMAIN', 'TILLBAY', 'TILLGAR', 'TILLROCK', 'TILLMANZ', 'TILLPAC', 'TILLBKM', 'TILLOUT')
    AND statistics.type IN ('issue', 'renew')
    AND statistics.datetime BETWEEN <<Start date|date>> AND <<End date|date>>
GROUP BY 
    branches.branchname, itemtypes.description
ORDER BY 
    branches.branchname, itemtypes.description