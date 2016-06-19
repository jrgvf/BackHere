$(function() {
  var types_allow_full_task = ['import_orders', 'import_customers'];

  $('#task-scheduler-infos').hide();

  $('#task_now').on('ifChecked', function(event){
    $('#task-scheduler-infos').hide(500);

    var opt = $('input[name="generic_type"]:checked').val();

    if ($.inArray(opt, types_allow_full_task) >= 0) {
      $('#full_task').iCheck('enable');
    }
  });

  $('#task_schedule').on('ifChecked', function(event){
    $('#task-scheduler-infos').show(500);
    $('#full_task').iCheck('uncheck');
    $('#full_task').iCheck('disable');
  });

  $('input[name="generic_type"]').on('ifClicked', function(event){
    var opt = $(this).val();

    if ($.inArray(opt, types_allow_full_task) >= 0) {
      if (!$('#task_schedule').prop("checked")) {
        $('#full_task').iCheck('enable');
      }
    } else {
      $('#full_task').iCheck('uncheck');
      $('#full_task').iCheck('disable');
    }
  });

});