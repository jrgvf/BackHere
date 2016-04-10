$(function() {
  $('form.edit_status').on('ajax:success', function(e, data, status, xhr) {
    // window.setTimeout(function(){
    //     bootbox.hideAll();
    // }, 1500);
    // bootbox.alert('Status atualizado com sucesso!');
  }).on("ajax:error", function(e, xhr, status, error) {
    bootbox.alert("Ops... <br /><br />" + xhr.responseText);
  });

  $('#update_all_status').on('click', function() {
    var button_text = $('#update_all_status span').attr('button-text');
    $('i.fa-refresh').addClass("fa-spin fa-lg");
    $('#update_all_status span').text('');
    window.setTimeout(function(){
      $('i.fa-refresh').removeClass("fa-spin fa-lg");
      $('#update_all_status span').text(button_text);
    }, 2000);
    $('form.edit_status').each(function() {
      $(this).submit();
    });
  });

});