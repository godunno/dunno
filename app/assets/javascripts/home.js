//= require jquery
//= require foundation/foundation
//= require foundation/foundation.topbar
//= require wow

$(function () {
  $(document).foundation();

  // TODO: convert to function
  // TODO: add slider behaviour (automatic switching)
  // TODO: add wow animated effect on change
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

  wow = new WOW(
    {
      boxClass:     'wow',      // default
      animateClass: 'animated', // default
      offset:       300,
      mobile:       true,       // default
      live:         true        // default
    }
  )
  wow.init();
});

