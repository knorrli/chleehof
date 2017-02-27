(function() {
  $('#lightbox').on('show.bs.modal', function (event) {
    var image = $(event.relatedTarget);
    var modal = $(this);
    console.log(image.attr('src'));
    modal.find('.modal-content #image').attr('src', image.attr('src'));
  });
})();
