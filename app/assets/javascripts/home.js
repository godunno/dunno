//= require jquery
//= require foundation/foundation
//= require foundation/foundation.topbar
//= require foundation/foundation.reveal
//= require wow
//= require greensock
//= require greensock/plugins/ScrollToPlugin
//= require scrollmagic
//= require scrollmagic/plugins/animation.gsap

$(function () {
  $(document).foundation({
    topbar: {
      start_offset: 140
    }
  });

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
      boxClass: 'wow',
      animateClass: 'animated',
      offset: 300,
      mobile: true,
      live: true
    }
  )
  wow.init();

  var controller = new ScrollMagic.Controller();

  var scene = new ScrollMagic.Scene({
    triggerElement: '#quero-usar-o-Dunno',
    duration: 200,
    triggerHook: 'onLeave'
  }).addTo(controller);

  controller.scrollTo(function (newpos) {
    TweenMax.to(
      window,
      1.5,
      {
        scrollTo: { y: newpos },
        // TODO: investigate how to add this only at the end of the tween
        onComplete: focusField('#invitation__email')
      }
    )
  });

  $(document).on('click', '.invitation__link', function (e) {
    var id = $(this).attr('href');
    if ($(id).length > 0) {
      e.preventDefault();
      controller.scrollTo(id);
      if (window.history && window.history.pushState) {
        history.pushState('', document.title, id);
      }
    }
  });
});

function focusField(element) {
  $(element).focus();
}
