(function() {
  // rounds exactly without errors
  function rounded(value, decimals) {
    return Number(Math.round(value+'e'+decimals)+'e-'+decimals);
  }

  // rounds to nearest .05 decimal
  function rounded05(value) {
    var roundedValue = rounded(value, 2);
    return Math.round(roundedValue*20)/20;
  }

  var cashDiscountTreshold = $("#order_cash_discount").data('treshold');
  var cashDiscountPercentage = $("#order_cash_discount").data('percentage');
  var bulkDiscountTreshold = $("#order_bulk_discount").data('treshold');
  var bulkDiscountPercentage = $("#order_bulk_discount").data('percentage');
  var springDiscountPercentage = $("#order_spring_discount").data('percentage');
  var vatPercentage = Number($("#order_vat_percentage").val());

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
    var totalInclItemDiscount = totalPriceExclVat;

    // SPRING DISCOUNT
    if ($('#spring-discount-row').length > 0) {
      $("#spring-discount-row .discounted_total").html(rounded(totalPriceExclVat, 2).toFixed(2));
      var springDiscount = calculateSpringDiscount(totalPriceExclVat);
      currentTotalPrice += springDiscount;
      totalInclItemDiscount = currentTotalPrice;
      setReadonly("#order_spring_discount", rounded(springDiscount, 2).toFixed(2));
    }
    $("#spring_discount").html(rounded(currentTotalPrice, 2).toFixed(2));
    $("#cash-discount-row .discounted_total").html(rounded(totalInclItemDiscount, 2).toFixed(2));
    $("#bulk-discount-row .discounted_total").html(rounded(totalInclItemDiscount, 2).toFixed(2));


    // CASH DISCOUNT
    var cashDiscountActive = $("#order_payed_cash").prop('checked');
    console.log("Threshold", cashDiscountTreshold);
    if (!cashDiscountActive || (totalPriceExclVat < cashDiscountTreshold)) {
      setReadonly("#order_cash_discount", "0.00");
    } else {
      console.log("Discounting Cash Discount");
      var cashDiscount = calculateCashDiscount(totalInclItemDiscount);
      currentTotalPrice += cashDiscount;
      setReadonly("#order_cash_discount", rounded(cashDiscount, 2).toFixed(2));
    }
    $("#cash_discount").html(rounded(currentTotalPrice, 2).toFixed(2));


    // BULK DISCOUNT
    if (totalPriceExclVat < bulkDiscountTreshold) {
      $("#bulk-discount-row").addClass('hidden');
      setReadonly('#order_bulk_discount', "0.00");
    } else {
      $("#bulk-discount-row").removeClass('hidden');
      var bulkDiscount = calculateBulkDiscount(totalInclItemDiscount);
      currentTotalPrice += bulkDiscount;
      setReadonly("#order_bulk_discount", rounded(bulkDiscount, 2).toFixed(2));
    }
    $("#bulk_discount").html(rounded(currentTotalPrice, 2).toFixed(2));

    // VAT
    $("#total-vat-row .vat_basis").html(rounded(currentTotalPrice, 2).toFixed(2));
    var vatAmount = calculateVatAmount(currentTotalPrice);
    setReadonly('#order_vat_amount', rounded(vatAmount, 2).toFixed(2));
    currentTotalPrice += vatAmount;
    $("#total-vat-row .total-price").html(rounded(currentTotalPrice, 2).toFixed(2));

    // TOTAL INCL VAT
    $("#total-incl-vat-row .total-price").html(rounded(currentTotalPrice, 2).toFixed(2));

    
    // SHIPPING COST
    var shippingCost = Number($("#order_shipping_cost").val());
    if (!shippingCost) {
      shippingCost = 0;
      $("#order_shipping_cost").val(shippingCost.toFixed(2));
    }
    currentTotalPrice += shippingCost;
    $("#shipping-cost-row .total-price").html(rounded(currentTotalPrice, 2).toFixed(2));

    const totalPrice = rounded05(currentTotalPrice);
    const roundingDifference = (totalPrice - currentTotalPrice).toFixed(2);

    // ROUNDING DIFFERENCE
    $("#rounding-difference-row .rounding-difference").html(roundingDifference);

    // TOTAL PRICE
    $("#total-price-row .quantity").html(totalQuantity);
    $("#total-price-row .price_value").html(totalPrice.toFixed(2));
  }

  var calculateCashDiscount = function(totalPriceExclVat) {
    return totalPriceExclVat*(cashDiscountPercentage/100)*-1;
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

  var deleteItem = function() {
    item = $(this).parents(".order-item");
    item.find('.quantity_input').val(0);
    item.addClass('deleted');
    recalculate();
  }

  $(document).ready(function() {
    // initial calculation for existing items
    if ($("#order-form").length > 0) {
      recalculate();
    }

    $("#order-form .order-item-table").off('change', recalculate);
    $("#order-form .order-item-table").on('change', recalculate);


    $("#order-form").off('click', deleteItem);
    $("#order-form").on('click', '.delete-item', deleteItem);
  });
})();

