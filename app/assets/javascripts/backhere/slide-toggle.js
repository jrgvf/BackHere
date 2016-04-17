$(function() {

  $('.backhere-slide-toggle').each(function() {
    startToggle(this);
  });

  $('.slide-toggle-button').on('click', function() {
    changeAngle(this);
    slideTable(this, 500);
  });
  
  function changeAngle (button) {
    var icon = $(button).children().last();

    if(icon.hasClass('fa-angle-double-down')) {
      icon.removeClass('fa-angle-double-down');
      icon.addClass('fa-angle-double-right');
    } else {
      icon.addClass('fa-angle-double-down');
      icon.removeClass('fa-angle-double-right');
    }
  };

  function slideTable (button, slide_time) {
    var sliderElement = $(button).parent().nextAll('.table-responsive')
    sliderElement.slideToggle(slide_time);
  };

  function startToggle (slide_div) {
    var auto_open = $(slide_div).attr('auto-open') == "true"
    var size = $(slide_div).children('.table-responsive').find('tr').size();
    if ( size > 1 && auto_open ) {
      var button = $(slide_div).find(".slide-toggle-button"); 
      changeAngle(button);
    } else {
      $(slide_div).children('.table-responsive').toggle();
    };
  };

});
