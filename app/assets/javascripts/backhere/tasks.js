$(function() {
  $('#task-scheduler-infos').hide();

  $('#task_now').on('ifChecked', function(event){
    $('#task-scheduler-infos').hide(500);
    $('#full_task').iCheck('enable');
  });

  $('#task_schedule').on('ifChecked', function(event){
    $('#task-scheduler-infos').show(500);
    $('#full_task').iCheck('uncheck');
    $('#full_task').iCheck('disable');
  });

});