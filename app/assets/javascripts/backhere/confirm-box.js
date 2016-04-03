var ready;

ready = function() {
  window.myCustomConfirmBox = function(message, callback) {
    return bootbox.dialog({
      message: message,
      "class": 'class-confirm-box',
      className: "my-modal",
      buttons: {
        cancel: {
          label: '<span class="btn-label"><i class="glyphicon glyphicon-remove"></i></span><b>Cancelar</b>',
          className: "btn-labeled btn-danger"
        },
        ok: {
          label: '<span class="btn-label"><i class="glyphicon glyphicon-ok"></i></span><b>Continuar</b>',
          className: "btn-labeled btn-success",
          callback: function() {
            return callback();
          }
        }
      }
    });
  };
  return $.rails.allowAction = function(element) {
    var answer, callback, message;
    message = element.data("confirm");
    if (!message) {
      return true;
    }
    answer = false;
    callback = void 0;
    if ($.rails.fire(element, "confirm")) {
      myCustomConfirmBox(message, function() {
        var oldAllowAction;
        callback = $.rails.fire(element, "confirm:complete", [answer]);
        if (callback) {
          oldAllowAction = $.rails.allowAction;
          $.rails.allowAction = function() {
            return true;
          };
          element.trigger("click");
          return $.rails.allowAction = oldAllowAction;
        }
      });
    }
    return false;
  };
};

$(document).ready(ready);

$(document).on('page:load', ready);