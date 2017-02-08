(function() {

  var updateTotals = function(e) {
    var $quantityInput = $(this);
    calculateTotalProductPrice($quantityInput);
    calculateTotalOrderPrice();
  }

  var calculateTotalProductPrice = function($quantityInput) {
    var quantity = $quantityInput.val();
    var $productRow = $quantityInput.parents('.product');
    var price = $productRow.find('.price .price_value').html();
    var productTotal = quantity * price;
    var $productTotalInput = $productRow.find('.total-price .price_value');
    $productTotalInput.html(productTotal)
  }

  var calculateTotalOrderPrice = function() {
    var totalQuantity = 0;
    var totalPrice = 0;
    $('#order-form .products').find('.product').each(function(index) {
      $productRow = $(this);
      var totalProductQuantity = $productRow.find('.quantity input').val();
      var totalProductPrice = $productRow.find('.total-price .price_value').html();
      totalQuantity += parseInt(totalProductQuantity) || 0;
      totalPrice += parseInt(totalProductPrice) || 0;
    });
    $('#order-form').find('.total-row .quantity').html(totalQuantity);
    $('#order-form').find('.total-row .total-price .price_value').html(totalPrice);
  }

  var calculateAllTotals = function() {
    $('#order-form td input').each(function(a) {
      calculateTotalProductPrice($(this));
    });
    calculateTotalOrderPrice();
  }

  $(document).ready(function() {
    $('#order-form').off('change', updateTotals);
    $('#order-form').on('change', 'td input', updateTotals);

    calculateAllTotals();
  });
})();
