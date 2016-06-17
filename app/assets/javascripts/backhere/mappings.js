$(function() {

  $('#survey_mapping_form').on("ajax:error", function(e, xhr, status, error) {
    bootbox.alert("Ops... <br /><br />" + xhr.responseText);
  });

  $('a[data-method="delete"]').on("ajax:error", function(e, xhr, status, error) {
    bootbox.alert("Ops... <br /><br />" + xhr.responseText);
  });

});