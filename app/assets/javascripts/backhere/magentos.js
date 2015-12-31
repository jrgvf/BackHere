$(function() {
  $('#magento_url').on('input', function() {
     var url_base = $(this).val();
     var starts_with_protocol = url_base.match(/^http/) 
     var ends_with_slash = url_base.match("\/$");
     if (!starts_with_protocol) {
      url_base = 'http://' + url_base;
     }
     if (!ends_with_slash) {
      url_base = url_base + '/';
     }
     api_path = "index.php/api/v2_soap?wsdl=1";
     $('#magento_api_url').val(url_base + api_path);
  });

  $('a.update-specific-version').on('ajax:success', function(e, data, status, xhr) {
    $(this).closest("tr").find("td.p-specific_version").text($.parseJSON(xhr.responseText).specific_version);
    bootbox.alert('Versão específica atualizada com sucesso!');
  }).on("ajax:error", function(e, xhr, status, error) {
    bootbox.alert("Tem algo errado ai... <br /><br />" + xhr.responseText);
  });

});