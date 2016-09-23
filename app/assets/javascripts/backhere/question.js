$(function (){

  optionsVerification();

  function optionsVerification() {
    $('select#type').each(function() {
      optionsToggle(this, 0);
    });

    $('select#type').change(function (){
      optionsToggle(this, 1000);
    });
  };

  function optionsToggle (select_field, hide_time) {
    var types_with_options = ['multi_choice', 'choice', 'linear_scale'];
    var opt = $(select_field).val();

    if ($.inArray(opt, types_with_options) >= 0) {
      $(select_field).parents('#form_question').find('#options').show(1000);
      $(select_field).parents('#form_question').find('#other_option').show(1000);
    } else {
      $(select_field).parents('#form_question').find('#options').hide(hide_time);
      $(select_field).parents('#form_question').find('#other_option').hide(hide_time);
    }
  };

});