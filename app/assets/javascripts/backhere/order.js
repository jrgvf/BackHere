$(function() {

  $('table.center th').addClass("center");

  $('input[data-name="available_for_survey"]').bootstrapSwitch();

  $('input[data-name="available_for_survey"]').on('switchChange.bootstrapSwitch', function(event, state) {
    $(this).closest('form').submit();
  });

  $('input[data-name="available_for_survey"]').closest('form').on("ajax:error", function(e, xhr, status, error) {
    bootbox.alert("Ocorreu um erro e não foi possível salvar o pedido.<br /><br />Erro(s):<br />" + xhr.responseText);
    setTimeout(function() {location.reload()}, 1000);
  });

});