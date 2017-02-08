(function() {
  var confirmDestroy = function() {
    return confirm("Wirklick löschen?");
  }

  $(document).ready(function() {
    $('.destroy-product').off('submit', confirmDestroy);
    $('.destroy-product').on('submit', confirmDestroy);
  });
})();
