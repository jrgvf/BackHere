$(function (){

  $(document).on('page:load', loadWidgets());

  function loadWidgets() {
    if( $('body#account-dashboard').length == 0 ) return; // Return if not Dashboard

    ordersWidget();
    customersWidget();
    messagesWidget();
    surveysWidget();
    answersWidget();
    lastet_ordersWidget();
  }

  function ordersWidget() {
    $.ajax({
      type: 'GET',
      url: '/widgets/orders',
      cache: false,
      error: function() {
        $('#orders div').html("<h4>Não foi possível carregar.</br> Tente novamente mais tarde.</h4>")
      }
    });
  };

  function customersWidget() {
    $.ajax({
      type: 'GET',
      url: '/widgets/customers',
      cache: false,
      error: function() {
        $('#customers div').html("<h4>Não foi possível carregar.</br> Tente novamente mais tarde.</h4>")
      }
    });
  };

  function messagesWidget() {
    $.ajax({
      type: 'GET',
      url: '/widgets/messages',
      cache: false,
      error: function() {
        $('#messages-email div').html("<h4>Não foi possível carregar.</br> Tente novamente mais tarde.</h4>");
        $('#messages-sms div').html("<h4>Não foi possível carregar.</br> Tente novamente mais tarde.</h4>");
      }
    });
  };

  function surveysWidget() {
    $.ajax({
      type: 'GET',
      url: '/widgets/surveys',
      cache: false,
      error: function() {
        $('#surveys div').html("<h4>Não foi possível carregar.</br> Tente novamente mais tarde.</h4>");
      }
    });
  };

  function answersWidget() {
    $.ajax({
      type: 'GET',
      url: '/widgets/answers',
      cache: false,
      error: function() {
        $('#answers div').html("<h4>Não foi possível carregar.</br> Tente novamente mais tarde.</h4>");
      }
    });
  };

  function lastet_ordersWidget() {
    $.ajax({
      type: 'GET',
      url: '/widgets/lastet_orders',
      cache: false,
      error: function() {
        $('#lastet_orders').html("<h4>Não foi possível carregar.</br> Tente novamente mais tarde.</h4>");
      }
    });
  };

});