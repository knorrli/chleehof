(function() {
  var vatPercentage = $("#vat-row").data('vat-percentage');
  var bulkDiscountTreshold = $("#order_bulk_discount").data('treshold');
  var bulkDiscountPercentage = $("#order_bulk_discount").data('percentage');
  var springDiscountPercentage = $("#order_spring_discount").data('percentage');

  var recalculate = function(e) {
    var form = $(this);
    var totalQuantity = 0;
    var totalPriceExclVat = 0;
    form.find(".order-item").each(function(i, item) {
      var item = $(item);
      var itemQuantity = Number(item.find('.quantity_input').val());
      var itemPrice = Number(item.find('.price_input').val());
      var itemTotalPrice = itemPrice * itemQuantity;
      totalQuantity += itemQuantity;
      totalPriceExclVat += itemTotalPrice;
      item.find('.total-price').html(itemTotalPrice.toFixed(2));
    });
    $("#total-excl-vat-row .quantity").html(totalQuantity);
    $("#total-incl-vat-row .quantity").html(totalQuantity);
    $("#total-excl-vat-row .price_value").html(totalPriceExclVat.toFixed(2));
    var bulkDiscount = calculateBulkDiscount(totalPriceExclVat);
    var springDiscount = calculateSpringDiscount(totalPriceExclVat);
    calculateTotalPriceInclVat(totalPriceExclVat, bulkDiscount, springDiscount);
  }

  var calculateTotalPriceInclVat = function(totalPriceExclVat, bulkDiscount, springDiscount) {
    var totalPriceWithDiscounts = totalPriceExclVat - bulkDiscount - springDiscount;
    var vatAmount = totalPriceWithDiscounts*(vatPercentage/100);
    $("#vat-row .vat_amount").html(vatAmount.toFixed(2));
    var totalPriceInclVat = totalPriceWithDiscounts + vatAmount;
    $("#total-incl-vat-row .price_value").html(totalPriceInclVat.toFixed(2));
  }

  var calculateBulkDiscount = function(totalPriceExclVat) {
    if (totalPriceExclVat < bulkDiscountTreshold) {
      return 0;
    }
    var discount = totalPriceExclVat*(bulkDiscountPercentage/100);
    $("#order_bulk_discount").val(discount.toFixed(2));
    return discount;
  }

  var calculateSpringDiscount = function(totalPriceExclVat) {
    // spring discount
    if ($('#spring-discount-row').length == 0) {
      return 0;
    }
    var discount = totalPriceExclVat*(springDiscountPercentage/100);
    $("#order_spring_discount").val(discount.toFixed(2));
    return discount;
  }

  $(document).ready(function() {
    $("#order-form .order-items").off('change', recalculate);
    $("#order-form .order-items").on('change', recalculate);
  });
})();

