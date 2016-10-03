$(function (){

  optionsVerification();

  $('#questions').on('cocoon:before-insert', function(e, object) {
    object.fadeToggle(1000);
  }).on('cocoon:after-insert', function() {
    optionsVerification();
  });

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
      $(select_field).parents('.box-body').find('#options').show(1000);
      $(select_field).parents('.box-body').find('#other_option').show(1000);
    } else {
      $(select_field).parents('.box-body').find('#options').hide(hide_time);
      $(select_field).parents('.box-body').find('#other_option').hide(hide_time);
    }
  };

  $('#filter_tags').on('click', function() {
    $.ajax({
    type: 'GET',
    url: '/surveys/:survey_id/filter_questions',
    cache: false,
    error: function() {
      bootbox.alert("Ocorreu um erro... :X");
    }
  });
  });

});