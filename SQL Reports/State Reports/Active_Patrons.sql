SELECT
    borrowers.branchcode AS homebranch,
    COUNT(DISTINCT borrowers.borrowernumber) AS active_patron_count
FROM
    borrowers
    JOIN statistics ON borrowers.borrowernumber = statistics.borrowernumber
WHERE
    borrowers.branchcode LIKE 'TILL%'
    AND borrowers.categorycode NOT IN ('STAFF')
    AND statistics.datetime BETWEEN '2024-07-01' AND '2025-06-30'
    AND statistics.type IN ('issue', 'renew', 'return')
GROUP BY
    borrowers.branchcode
ORDER BY
    borrowers.branchcode
