(function() {

  var autocompleteCustomers = function(e) {
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
    } else {
      emptyProductResultContainer();
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
        "<div class='new-customer-link'><a href='/admin/customers/new'>Neuer Kunde registrieren?</a></div>"
    }
    $('#customer-search-results').html(resultContent);
    showCustomerResultContainer();
  }

  var fillCustomerInfo = function() {
    debugger;
    hideCustomerResultContainer();
    var customer = JSON.parse(atob($(this).data('customer')));
    $("#order_customer_id").val(customer.id);
    $("#order_first_name").val(customer.first_name);
    $("#order_last_name").val(customer.last_name);
    $("#order_company").val(customer.company);
    $("#order_address_1").val(customer.address_1);
    $("#order_address_2").val(customer.address_2);
    $("#order_zip_code").val(customer.zip_code);
    $("#order_city").val(customer.city);
    $("#order_phone").val(customer.phone);
    $("#order_email").val(customer.email);
    $("#order_payed_cash").prop('checked', customer.pay_cash)
  }

  var emptyProductResultContainer = function() {
    $("#customer-search-results").empty();
  }

  var showCustomerResultContainer = function() {
    $('#customer-search-results').removeClass('hidden');
  }

  var hideCustomerResultContainer = function() {
    $('#customer-search-results').addClass('hidden');
  }

  $(document).ready(function() {
    $("#customer-search").on('keyup', autocompleteCustomers);

    $("#order-form").off('mousedown', fillCustomerInfo);
    $("#order-form").on('mousedown', '.customer-result', fillCustomerInfo);

    $("#customer-search").off('mousedown', renderNewCustomerForm);
    $("#customer-search").on('mousedown', '.new-customer-link', renderNewCustomerForm);
    $("#customer-search").focus(showCustomerResultContainer).blur(hideCustomerResultContainer);
  });
})();
