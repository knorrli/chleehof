(function() {

  var autocompleteProducts = function(e) {
    e.stopPropagation();
    var search = $(this);
    var input = search.val();
    if (input.length > 0) {
      var url = search.data('url');
      $.ajax({
        url: url,
        data: {q: input},
        type: 'GET',
        dataType: 'json',
        success: renderProductSearchResults,
      })
      showProductResultContainer();
    } else {
      hideProductResultContainer();
    }
  }

  var renderProductSearchResults = function(results, status) {
    var resultContent = "";
    if (results.length > 0) {
      for(result_index in results) {
        var result = results[result_index];
        var productInfo = `${result.identifier} | ${result.name}`
        var dataAttributes = `data-product=${btoa(JSON.stringify(result))}`
        resultContent = resultContent + `<div class='product-result search-result' ${dataAttributes}>${productInfo}</div>`
      }
    } else {
      resultContent = "<div>Keine Produkte gefunden</div>"
    }
    $('#product-search-results').html(resultContent);
  }

  var addOrderItem = function() {
    hideProductResultContainer();
    var product = JSON.parse(atob($(this).data('product')))
    if ($("#order-item-"+product.id).length == 0) {
      var item = orderItem(product);
      $("#order-items").append(item);
    }
    $(".order-items").find("#order-item-"+product.id+" .quantity_input").focus();

  }

  var showProductResultContainer = function() {
    $('#product-search-results').removeClass('hidden');
  }

  var hideProductResultContainer = function() {
    $('#product-search-results').addClass('hidden');
  }

  var orderItem = function(product) {
    var orderItemHTML =
      `<tr class="order-item" id="order-item-${product.id}">` +
      `<td class="col-md-1 identifier">${product.identifier}</td>` +
      `<td class="col-md-4 name">${product.name}</td>` +
      `<td class="col-md-1 quantity text-right">` +
      `<input type="text" name="order[order_items_attributes][${product.id}][quantity]" id="order_order_items_attributes_${product.id}_quantity" class="quantity_input form-control input-sm text-right">` +
      `</td>` +
      `<td class="col-md-1 multiplier text-center">x</td>` +
      `<td class="col-md-1 price">` +
      `<input type="text" name="order[order_items_attributes][${product.id}][price]" value="${product.price}" id="order_order_items_attributes_${product.id}_price" class="price_input form-control input-sm text-right">` +
      `</td>` +
      `<td class="col-md-2 total-price"></td>` +
      `</tr>`
    return orderItemHTML
  }

  $(document).ready(function() {
    $("#order-form").on('keyup', '#product-search', autocompleteProducts)

    $("#order-form").off('click', addOrderItem)
    $("#order-form").on('click', '.product-result', addOrderItem)
  });
})();
