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

  var surveyQuestions = document.getElementById('surveyQuestions');
  if (surveyQuestions !== null) { startSortable(surveyQuestions, true) }
  var othersQuestions = document.getElementById('othersQuestions');
  if (othersQuestions !== null) { startSortable(othersQuestions, false) }

  function startSortable (element, sort) {
    Sortable.create(element, {
      group: "sorting",
      ghostClass: 'ghost',
      sort: sort,
      onRemove: function (evt) { afterRemove(evt.from, evt.item) }
    });
  };

  function afterRemove (from, item) {
    if ($(from).is("#surveyQuestions")) {
      $(item).find('input[type="checkbox"]').prop('checked',false);
    } else {
      $(item).find('input[type="checkbox"]').prop('checked',true);
    }
  };

  $('#filter_tags').on('change', function(event) {
    event.preventDefault();

    var tags = $('select[name="filter_tags[]"]').val();
    var question_ids = []
    $("input:checked").each(function() {
      question_ids.push($(this).val());
    });

    $.ajax({
      type: 'GET',
      url: '/questions/filter',
      cache: false,
      data : { tags: tags, question_ids: question_ids },
      error: function() {
        bootbox.alert("Não foi possível filtrar as perguntas. <br /><br />Tente novamente mais tarde.");
      }
    });
  });

});