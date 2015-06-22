//= require jquery
//= require foundation/foundation
//= require foundation/foundation.topbar
//= require wow.min

$(function () {
  $(document).foundation();

  $('.feature').on('click', function (e) {
    e.preventDefault();
    var _self = $(this);
    var index = _self.data('feature');
    if (!_self.hasClass('active')) {
      $('.feature.active').removeClass('active');
      $(this).toggleClass('active');
      $('#features__screenshot')
        .removeClass()
        .addClass('features__screenshot showing__feature__'+index);
    }
  });

  new WOW().init();
});

