SELECT
    borrowers.branchcode AS homebranch,
    COUNT(*) AS patron_count
FROM
    borrowers
WHERE
    borrowers.branchcode LIKE 'TILL%'
    AND borrowers.categorycode NOT IN ('STAFF') -- Optional: exclude staff accounts
GROUP BY
    borrowers.branchcode
ORDER BY
    borrowers.branchcode;