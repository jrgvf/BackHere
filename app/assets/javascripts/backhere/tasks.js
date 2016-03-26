$(function() {
  $('.backhere-slide-toggle').children('.table-responsive').toggle();

  $('.slide-toggle-button').on('click', function() {
    changeAngle(this);
    slideTable(this, 500);
  });
  
  function changeAngle (button, icon) {
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
});
