SELECT 
    borrowers.branchcode,
    branches.branchname,
    COUNT(*) AS number_of_patrons_added
FROM 
    borrowers
LEFT JOIN 
    branches ON borrowers.branchcode = branches.branchcode
WHERE 
    borrowers.dateenrolled BETWEEN <<Start Date|date>> AND <<End Date|date>>
    AND borrowers.branchcode IN ('TILLMAIN', 'TILLBAY', 'TILLGAR', 'TILLROCK', 'TILLMANZ', 'TILLPAC', 'TILLBKM', 'TILLOUT')
GROUP BY 
    borrowers.branchcode, branches.branchname
ORDER BY 
    borrowers.branchcode