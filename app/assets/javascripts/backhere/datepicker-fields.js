$(function() {
  $('.datepicker').datepicker({
    // format: 'yyyy-mm-dd',
    language: 'pt-BR',
    autoclose: true
  });

  $('#clear-datepicker').click(function(){
    $(this).parents('.input-group').children('input.datepicker').val('');             
  });
});