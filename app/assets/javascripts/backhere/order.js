$(function() {

  $('input[data-name="available_for_survey"]').bootstrapSwitch();

  $('input[data-name="available_for_survey"]').on('switchChange.bootstrapSwitch', function(event, state) {
    console.log('this');
    $.ajax({
      type: "POST",
      url:
      data:
      dataType: "JSON"
    });
  });

});