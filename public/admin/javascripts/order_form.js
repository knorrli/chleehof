(function() {
  // rounds exactly without errors
  function rounded(value, decimals) {
    return Number(Math.round(value+'e'+decimals)+'e-'+decimals);
  }

  // rounds to nearest .05 decimal
  function rounded05(value) {
    var roundedValue = rounded(value, 2);
    return Math.ceil(roundedValue*20)/20;
  }

  var vatPercentage = Number($("#order_vat_percentage").val());
  var bulkDiscountTreshold = $("#order_bulk_discount").data('treshold');
  var bulkDiscountPercentage = $("#order_bulk_discount").data('percentage');
  var springDiscountPercentage = $("#order_spring_discount").data('percentage');

  var recalculate = function(e) {
    var form = $("#order-form");
    var totalQuantity = 0;
    var totalPriceExclVat = 0;
    form.find(".order-item").each(function(i, item) {
      var item = $(item);
      var itemQuantity = Number(item.find('.quantity_input').val());
      var itemPrice = Number(item.find('.price_input').val());
      var itemTotalPrice = itemPrice * itemQuantity;
      totalQuantity += itemQuantity;
      totalPriceExclVat += itemTotalPrice;
      item.find('.total-price').html(rounded(itemTotalPrice, 2).toFixed(2));
    });
    $("#total-excl-vat-row .quantity").html(totalQuantity);
    $("#total-excl-vat-row .price_value").html(rounded(totalPriceExclVat, 2).toFixed(2));

    var currentTotalPrice = totalPriceExclVat;
    // BULK DISCOUNT
    if (currentTotalPrice < bulkDiscountTreshold) {
      setReadonly('#order_bulk_discount', "");
      $("#bulk-discount-row .total-price").html(rounded(totalPriceExclVat, 2).toFixed(2));
    } else {
      var bulkDiscount = calculateBulkDiscount(totalPriceExclVat);
      currentTotalPrice += bulkDiscount;
      setReadonly("#order_bulk_discount", rounded(bulkDiscount, 2).toFixed(2));
      $("#bulk-discount-row .total-price").html(rounded(currentTotalPrice, 2).toFixed(2));
    }

    // SPRING DISCOUNT
    if ($('#spring-discount-row').length > 0) {
      var springDiscount = calculateSpringDiscount(totalPriceExclVat);
      currentTotalPrice += springDiscount;
      setReadonly("#order_spring_discount", rounded(springDiscount, 2).toFixed(2));
      $("#spring-discount-row .total-price").html(rounded(currentTotalPrice, 2).toFixed(2));
    }

    // VAT
    var vatAmount = calculateVatAmount(currentTotalPrice);
    setReadonly('#order_vat_amount', rounded(vatAmount, 2).toFixed(2));
    currentTotalPrice += vatAmount;
    $("#total-incl-vat-row .total-price").html(rounded(currentTotalPrice, 2).toFixed(2));

    // SHIPPING COST
    var shippingCost = Number($("#order_shipping_cost").val());
    currentTotalPrice += shippingCost;
    $("#shipping-cost-row .total-price").html(rounded(currentTotalPrice, 2).toFixed(2));

    // TOTAL PRICE
    $("#total-price-row .quantity").html(totalQuantity);
    $("#total-price-row .price_value").html(rounded05(currentTotalPrice).toFixed(2));
  }

  var calculateBulkDiscount = function(totalPriceExclVat) {
    return totalPriceExclVat*(bulkDiscountPercentage/100)*-1;
  }

  var calculateSpringDiscount = function(totalPriceExclVat) {
    return totalPriceExclVat*(springDiscountPercentage/100)*-1;
  }

  var calculateVatAmount = function(currentTotalPrice) {
    return currentTotalPrice*(vatPercentage/100);
  }

  var setReadonly = function(identifier, value) {
    $(identifier).prop('readonly', false);
    $(identifier).val(value);
    $(identifier).prop('readonly', true);
  }

  $(document).ready(function() {
    // initial calculation for existing items
    recalculate();

    $("#order-form .order-item-table").off('change', recalculate);
    $("#order-form .order-item-table").on('change', recalculate);
  });
})();

