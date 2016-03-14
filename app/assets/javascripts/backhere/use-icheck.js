function icheck(){
  if($(".icheck-me").length > 0){
    $(".icheck-me").each(function(){
      var $el = $(this);
      var skin = ($el.attr('data-skin') !== undefined) ? "_" + $el.attr('data-skin') : "";
      var color = ($el.attr('data-color') !== undefined) ? "-" + $el.attr('data-color') : "";
      var opt = {
        checkboxClass: 'icheckbox' + skin + color,
        radioClass: 'iradio' + skin + color
      };
      $el.iCheck(opt);
    });
  }
}

$(function(){
  icheck();
});

$(function(){
  $('input').on('ifClicked', function(event){
    if($(this).parent().hasClass("checked")){
      $(this).iCheck('uncheck');
    }
    // } else {
    //   $('div.checked input[name=platform]').each(function(){
    //     $(this).iCheck('uncheck');
    //   })
    //   $(this).iCheck('check');
    // }
  });
});