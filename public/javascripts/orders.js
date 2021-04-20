(function() {
  var confirmDestroy = function() {
    return confirm("Wirklich löschen?");
  }

  var submitPaginationForm = function() {
    $("#order-pagination-form").submit();
  }

  $(document).ready(function() {
    $('.destroy-order').off('submit', confirmDestroy);
    $('.destroy-order').on('submit', confirmDestroy);

    $('#order-pagination-form').off('change', submitPaginationForm);
    $('#order-pagination-form').on('change', submitPaginationForm);
  });
})();
