!function($) {
  'use strict';

  $(function() {

    // Automatically close alerts if there was any present.
    if ($('.alert').length > 0) {
      setTimeout(function() { $('.alert').alert('close'); }, alertTimeout);
    }

    // Autofocus first field with an error. (usability)
    var error_input;
    if (error_input = $('.has-error :input').first()) { error_input.focus(); }
  });
}(window.jQuery);
