$(function () {
  $('ul.dropdown-menu a').click(function () {
    $(this).closest('ul').prev('button').dropdown('toggle');
  });
  // $('ul.dropdown-menu a[data-remote=true]').click(function () {
  //   $(this).closest('ul').prev('button').dropdown('toggle');
  // });
});