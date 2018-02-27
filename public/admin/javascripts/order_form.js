(function() {
  var recalculate = function(e) {
    var target = $(e.target);
    if (!$.isNumeric(target.val())) {
      alert("NOT A NUMBER");
      target.addClass('has-error');
      return;
    }
    var form = $(this);
    var totalQuantity = 0;
    var totalPriceExclVAT = 0;
    form.find(".order-item").each(function(i, item) {
      var item = $(item);
      var itemQuantity = item.find('.quantity_input').val();
      var itemPrice = item.find('.price_input').val();
      var itemTotalPrice = itemPrice * itemQuantity;
      totalQuantity += itemQuantity;
      totalPriceExclVAT += itemTotalPrice;
      item.find('.total-price').html(itemTotalPrice.toFixed(2));
    });
    $("#total-excl-vat-row quantity").html(totalQuantity);
    $("#total-excl-vat-row price-value").html(totalPriceExclVAT.toFixed(2));
    // applyBulkDiscount();
    // applySpringDiscount();
  }

  $(document).ready(function() {
    $("#order-form order-items").off('change', recalculate);
    $("#order-form order-items").on('change', recalculate);
  });
})();

