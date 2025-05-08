SELECT 
    /* Bibliographic record link */
    CONCAT(
        '<a class="btn btn-default btn-xs noprint"',
        'href="/cgi-bin/koha/catalogue/detail.pl?biblionumber=',
        item_info.biblionumber,
        '" target="_blank">BIBLIO</a>'
    ) AS 'LINK',
    
    /* Item information */
    item_info.HOME_LIBRARY,
    item_info.branchname AS CURRENT_LIBRARY,
    item_info.LOCATION,
    item_info.ITYPE,
    item_info.call_number,
    item_info.author,
    item_info.TITLE,
    item_info.datelastseen,
    item_info.barcode1,
    item_info.homebranch AS OWNED_BY,
    
    /* Transfer information */
    frombranches.branchname AS SENT_FROM,
    branchtransfers.datesent AS SENT_DATE,
    tobranches.branchname AS SENT_TO,
    branchtransfers.reason AS TRANSFER_REASON,
    
    /* Email link construction */
    CONCAT_WS('',
        '<a class="btn btn-default btn-xs noprint" ',
        'href="mailto:',
        item_info.branchemail,
        '?subject=Missing&nbsp;in&nbsp;transit&nbsp;',
        branchtransfers.branchtransfer_id,
        '&amp;cc=',
        frombranches.branchemail,
        ';',
        tobranches.branchemail,
        '&body=An%20item%20owned%20by%20&#42;&#42;',
        item_info.HOME_LIBRARY,
        '&#42;&#42;%20was%20shipped%20from%20&#42;&#42;',
        frombranches.branchname,
        '&#42;&#42;%20to%20&#42;&#42;',
        tobranches.branchname,
        '&#42;&#42;%20on%20',
        branchtransfers.datesent,
        '%20and%20the%20item%20has%20not%20yet%20arrived.',
        '%0D%0A%0D%0A',
        'The%20details%20are%20as%20follow%3A',
        '%0D%0A%0D%0A',
        'Branch%20transfer%20ID%3A%20',
        branchtransfers.branchtransfer_id,
        '%0D%0A%0D%0A',
        'Home%20library%3A%20',
        item_info.HOME_LIBRARY,
        '%0D%0ALocation%3A%20',
        item_info.LOCATION,
        '%0D%0AItem%20type%3A%20',
        item_info.ITYPE,
        '%0D%0ACollection%20code%3A%20',
        item_info.CCODE,
        '%0D%0ACall%20number%3A%20',
        item_info.CALL_NUMBER,
        '%0D%0AAuthor%3A%20',
        item_info.author,
        '%0D%0ATitle%3A%20',
        UPPER(REPLACE(item_info.TITLE, '&', 'and')),
        '%0D%0ABarcode%20number%3A%20',
        item_info.barcode,
        '%0D%0A%0D%0A',
        'Sent%20from%3A%20',
        frombranches.branchname,
        '%0D%0ASent%20to%3A%20',
        tobranches.branchname,
        '%0D%0ASent%20on%3A%20',
        branchtransfers.datesent,
        '%0D%0A%0D%0A',
        'Transfer%20reason%3A%20',
        branchtransfers.reason,
        '%20%0D%0A%0D%0A',
        'Could%20you%20please%20check%20the%20shelves%20at%20your%20library%20',
        '&#40;including%20the%20hold%20shelf&#41;%20',
        'and%20check%20this%20item%20in%20if%20you%20find%20it&#63;',
        '%0D%0A%0D%0A',
        'Thank you,',
        '%20%0D%0A%0D%0A',
        '">Send e-mail</a>'
    ) AS MAILTO_LINK
FROM 
    branchtransfers
    JOIN branches frombranches ON branchtransfers.frombranch = frombranches.branchcode
    JOIN branches tobranches ON branchtransfers.tobranch = tobranches.branchcode
    JOIN (
        SELECT 
            items.biblionumber,
            items.itemnumber,
            items.barcode,
            home.branchname AS HOME_LIBRARY,
            holding.branchname,
            perm_locs.lib AS PERM_LOCATION,
            CONCAT_WS('',
                perm_locs.lib,
                IF(locs.lib = 'Recently returned', ' (Recently returned)', '')
            ) AS LOCATION,
            itemtypes.description AS ITYPE,
            ccodes.lib AS CCODE,
            items.itemcallnumber,
            CONCAT_WS('',
                items.itemcallnumber,
                IF(items.copynumber IS NULL, '', CONCAT(' (Copy number: ', items.copynumber, ')'))
            ) AS CALL_NUMBER,
            biblio.author,
            CONCAT_WS(' ', 
                biblio.title, 
                biblio.medium, 
                biblio.subtitle,
                biblioitems.number, 
                biblio.part_name
            ) AS TITLE,
            items.datelastseen,
            items.copynumber,
            CONCAT('-', items.barcode, '-') AS barcode1,
            items.homebranch,
            home.branchemail
        FROM 
            items
            JOIN biblio ON items.biblionumber = biblio.biblionumber
            JOIN biblioitems ON biblioitems.biblionumber = biblio.biblionumber
            LEFT JOIN (
                SELECT 
                    authorised_values.category,
                    authorised_values.authorised_value,
                    authorised_values.lib,
                    authorised_values.lib_opac
                FROM 
                    authorised_values
                WHERE 
                    authorised_values.category = 'LOC'
            ) perm_locs ON perm_locs.authorised_value = items.permanent_location
            LEFT JOIN (
                SELECT 
                    authorised_values.category,
                    authorised_values.authorised_value,
                    authorised_values.lib,
                    authorised_values.lib_opac
                FROM 
                    authorised_values
                WHERE 
                    authorised_values.category = 'LOC'
            ) locs ON locs.authorised_value = items.location
            LEFT JOIN itemtypes ON itemtypes.itemtype = items.itype
            LEFT JOIN (
                SELECT 
                    authorised_values.category,
                    authorised_values.authorised_value,
                    authorised_values.lib,
                    authorised_values.lib_opac
                FROM 
                    authorised_values
                WHERE 
                    authorised_values.category = 'CCODE'
            ) ccodes ON ccodes.authorised_value = items.ccode
            LEFT JOIN branches home ON home.branchcode = items.homebranch
            LEFT JOIN branches holding ON holding.branchcode = items.holdingbranch
        GROUP BY 
            items.biblionumber,
            items.itemnumber
    ) item_info ON item_info.itemnumber = branchtransfers.itemnumber
WHERE 
    branchtransfers.datearrived IS NULL
    AND branchtransfers.datecancelled IS NULL
    AND CONCAT_WS(' | ',
        item_info.homebranch,
        branchtransfers.frombranch,
        branchtransfers.tobranch
    ) LIKE CONCAT('%', <<Choose your library|branches>>, '%')
    AND branchtransfers.datesent < CURDATE() - INTERVAL 1 MONTH
GROUP BY 
    item_info.biblionumber,
    item_info.itemnumber
ORDER BY 
    item_info.PERM_LOCATION,
    item_info.ITYPE,
    item_info.CCODE,
    item_info.itemcallnumber,
    item_info.author,
    item_info.TITLE,
    item_info.copynumber