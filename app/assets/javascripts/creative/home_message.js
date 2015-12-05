$(document).ready(function() {
  return $("#home_message").on("ajax:success", function(e, data, status, xhr) {
    bootbox.alert('Mensagem enviada com sucesso!');
  }).on("ajax:error", function(e, xhr, status, error) {
    bootbox.alert("Tem algo errado ai... <br /><br />Veja bem...<br /><br />" + xhr.responseText);
  });
});

// Outra maneira de fazer a mesma coisa. Aeenas para servir de exemplo
//
// $(function() {

//   function sendMessage() {
//     $("#home_message").on('ajax:success', function(e, data, status, xhr) {
//       bootbox.alert('Mensagem enviada com sucesso!');
//     }).on("ajax:error", function(e, xhr, status, error) {
//       bootbox.alert("Tem algo errado ai... <br /><br />" + xhr.responseText);
//     });
//   };

//   $(function(){
//     sendMessage();
//   });

// });