(function() {
  var confirmLeave = function() {
    return confirm("Hast du alle Daten gespeichert?");
  }

  $(document).ready(function() {
    if (document.getElementById('inventory-form')) {
      // window.onbeforeunload = confirmLeave;
    }
  });
})();
