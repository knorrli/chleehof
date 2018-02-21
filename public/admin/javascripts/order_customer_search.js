(function() {

  var autocompleteCustomers = function(e) {
    e.stopPropagation();
    var search = $(this);
    var input = search.val();
    if (input.length > 2) {
      var url = search.data('url');
      $.ajax({
        url: url,
        data: {q: input},
        type: 'GET',
        dataType: 'json',
        success: renderCustomerSearchResults
      })
      showCustomerResultContainer();
    } else {
      hideCustomerResultContainer();
    }
  }

  var renderCustomerSearchResults = function(results, status) {
    var resultContent = "";
    if (results.length > 0) {
      for(result_index in results) {
        var result = results[result_index];
        var customerInfo = `${result.name}, ${result.address_1}`
        var dataAttributes = `data-customer=${btoa(JSON.stringify(result))}`
        resultContent = resultContent + `<div class='customer-result search-result' ${dataAttributes}>${customerInfo}</div>`
      }
    } else {
      resultContent = "<div>Keine Kunden gefunden</div>" +
        "<div><a href='/admin/customers/new'>Neuer Kunde registrieren?</a></div>"
    }
    $('#customer-search-results').html(resultContent);
  }

  var fillCustomerInfo = function() {
    var customer = $(this);
    var customerData = JSON.parse(atob(customer.data('customer')));
    hideCustomerResultContainer();
    $("#order_first_name").val(customerData.first_name);
    $("#order_last_name").val(customerData.last_name);
    $("#order_company").val(customerData.company);
    $("#order_address_1").val(customerData.address_1);
    $("#order_address_2").val(customerData.address_2);
    $("#order_zip_code").val(customerData.zip_code);
    $("#order_city").val(customerData.city);
    $("#order_phone").val(customerData.phone);
    $("#order_email").val(customerData.email);
  }

  var emptyCustomerResultsContainer = function() {
    $("#customer-search-results").html("");
  }

  var showCustomerResultContainer = function() {
    $('#customer-search-results').removeClass('hidden');
  }

  var hideCustomerResultContainer = function() {
    $('#customer-search-results').addClass('hidden');
  }

  $(document).ready(function() {
    $("#order-form").on('keyup', '#customer-search', autocompleteCustomers)

    $("#order-form").off('click', fillCustomerInfo)
    $("#order-form").on('click', '.customer-result', fillCustomerInfo)
  });
})();
