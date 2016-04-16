$(function() {
  $('form.edit_status').on("ajax:error", function(e, xhr, status, error) {
    bootbox.alert("Ops... <br /><br />" + xhr.responseText);
  });

  $('form.new_status').on('ajax:error', function(e, xhr, status, error) {
    bootbox.alert("Ops... <br /><br />" + xhr.responseText);
  });

  $('#update_all_status').on('click', function() {
    var should_animate = true;
    var button_text = $('#update_all_status span').attr('button-text');

    $(document).on('ajaxStart', function() {
      if (should_animate) {
        $('#update_all_status span').text('');
        $('i.fa-refresh').addClass("fa-spin fa-lg");        
      };
    });

    $(document).on('ajaxStop',  function() {
      if (should_animate) {
        $('i.fa-refresh').removeClass("fa-spin fa-lg");
        $('#update_all_status span').text(button_text);
        should_animate = false;
      };
    });

    $('form.edit_status').each(function() {
      $(this).submit();
    });
  });

});