(function() {
  var confirmDestroy = function() {
    return confirm("Wirklich löschen?");
  }

  $(document).ready(function() {
    $('.destroy-customer').off('submit', confirmDestroy);
    $('.destroy-customer').on('submit', confirmDestroy);
  });
})();
