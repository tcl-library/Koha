 //*Causes the user cardnumber to auto populate to the Username
if ( $('#pat_memberentrygen').length > -1 ) {
    $("#entryform #cardnumber").blur(function(){
        $("#entryform #userid").val($("#entryform #cardnumber").val());
    }); 
}


$(document).ready(function () {
 /* create key value pairs like this, branchcode: 'baseurl' */
 const library_aspen_url = {
 N: '<a target="_blank" data-stringify-link="https://chinooklibraries.aspendiscovery.org" delay="150" data-sk="tooltip_parent" href="https://chinooklibraries.aspendiscovery.org/" rel="noopener noreferrer">https://chinooklibraries.aspendiscovery.org</a>',
 CLATSOPCC: 'https://clatsop.aspendiscovery.org',
 DRIFTWOOD: 'https://driftwood.aspendiscovery.org',
 LCLD: 'https://lcld.aspendiscovery.org',
 NEWPORT: 'https://newportlibrary.aspendiscovery.org',
 OCCC: 'https://oregoncoast.aspendiscovery.org',
 SILETZ: 'https://siletz.aspendiscovery.org',
 TBCC: 'https://tillamookbay.aspendiscovery.org',
 TILLMAIN: 'https://tillamookcounty.aspendiscovery.org', 
 TILLBAY: 'https://tillamookcounty.aspendiscovery.org',
 TILLBKM: 'https://tillamookcounty.aspendiscovery.org', 
 TILLGAR: 'https://tillamookcounty.aspendiscovery.org', 
 TILLMANZ: 'https://tillamookcounty.aspendiscovery.org', 
 TILLOUT: 'https://tillamookcounty.aspendiscovery.org', 
 TILLPAC: 'https://tillamookcounty.aspendiscovery.org', 
 TILLROCK: 'https://tillamookcounty.aspendiscovery.org',
 TOLEDO: 'https://toledo.aspendiscovery.org',
 WALDPORT: 'https://waldport.aspendiscovery.org'
 
 };
 let librarybranch = $('.logged-in-branch-code:first').text();
 Object.keys(library_aspen_url).forEach(function (item) {
 if ( item === librarybranch ) {
 /* change OPAC link on record detail page*/
 if ( $('#catalog_detail').length ) {
 let bib = $('input[name="bib"]').val();
 $('.results_summary > a:contains("Open in new window")').attr('href' , `${library_aspen_url[item]}/Record/${bib}`); 
 }

 /* change OPAC link on subscription detail page*/
 if ( $('#ser_subscription-detail').length ) {
 let bibtext = $('#subscription_info ol > li > i').text();
 let re = /\(([^\)]+)\)/;
 let bib = bibtext.match(re);
 $('#view-subscription-in-opac').attr('href' , `${library_aspen_url[item]}/Record/${bib[1]}`);
 }

/* change OPAC link in search results*/
if ($('#catalog_results').length) {
 $('#searchresults table tbody tr').each(function() {
 let bib = $(this).find('input[name="biblionumber"]').val();
 $(this).find('.view-in-opac > a').attr('href', `${library_aspen_url[item]}/Record/${bib}`);
 });
}
 }
 });
});

//*Make alert for attempted checkout of item that is on hold (not trapped, not waiting) for a different patron blue. This contrasts to the default yellow (on hold waiting for a different patron)*/
   if ( $('#circ_circulation').length ) {
        if ( $('li:contains(" has been on hold for")').length ) {
            $('li:contains(" has been on hold for")').closest('#circ_needsconfirmation').css('background' , 'lightblue');
        }
    }


/*Hide most Reports on Reports landing page*/
$(document).ready(function(){
    if ( $('#rep_reports-home').length ) {
        $('.col-xs-6  > ul').hide();
        $('.col-xs-6  > h2').hide();
        $('.col-xs-6  > h5').hide();
        $('.col-xs-6 form').append('<h2><a href="https://schema.koha-community.org/23_05/" target="blank">Koha database schema</a><h2><h2><a href="http://wiki.koha-community.org/wiki/SQL_Reports_Library" target="blank">Koha reports library</a></h2>');}});


/*Always show checkouts*/
 
 $(document).ready(function() {
    if ($('#issues-table-load-immediately').length) {
        $('#issues-table-load-immediately').prop('checked', true);
        Cookies.set("issues-table-load-immediately-" + script, true, { expires: 365 });
    }
});


/*adds clear search button to catalog results page. RT 59707 6.26.19 lg*/
$(document).ready(function () {
  if ( $('#catalog_results').length ) {
    $('<button id="clearsearch">Clear</button>').insertAfter( $('#cat-search-block') );
  }
  $('#clearsearch').click( function () {
    $('#search-form').attr('value' , '');
  });
});



$(document).ready(function () {
   if ( $('#circ_request').length && $('#pickup').length ) {
      $('.pickup_locations').each( function() {
           $(this).val(null).trigger('change');
      });
   }   
});


/*Update checkin button link but only for Driftwood, Newport, Toledo, & Tillamook Libraries*/

$(function () {
  const branch = $('.logged-in-branch-code').data('logged-in-branch-code');

  if (
    branch === 'NEWPORT' ||
    branch === 'DRIFTWOOD' ||
    branch === 'TOLEDO' ||
    branch.startsWith('TILL')    
  ) {
    const $checkinLink = $('#checkin_search-tab');
    $checkinLink.attr('href', 'https://staff.lcld.bywatersolutions.com/cgi-bin/koha/circ/returns.pl');
    $checkinLink.attr('data-bs-target', null);
    $checkinLink.removeAttr('data-bs-toggle');
  }
});