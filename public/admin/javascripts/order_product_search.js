(function() {

  var orderItem = function(product) {
    var orderItemHTML = `<tr>` +
      `<td>${product.identifier}</td>` +
      `<td>${product.name}</td>` +
      `<td>` +
        `<input type='text' name=''`
      `</td>`
    `</tr>`
    return orderItemHTML
  }

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
    var item = orderItem(product);
    debugger;
    $("#order-items").append(item);
  }

  var showProductResultContainer = function() {
    $('#product-search-results').removeClass('hidden');
  }

  var hideProductResultContainer = function() {
    $('#product-search-results').addClass('hidden');
  }

  $(document).ready(function() {
    $("#order-form").on('keyup', '#product-search', autocompleteProducts)

    $("#order-form").off('click', addOrderItem)
    $("#order-form").on('click', '.product-result', addOrderItem)
  });
})();
