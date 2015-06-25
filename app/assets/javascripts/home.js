//= require jquery
//= require foundation/foundation
//= require foundation/foundation.topbar
//= require wow
//= require greensock
//= require greensock/plugins/ScrollToPlugin
//= require scrollmagic
//= require scrollmagic/plugins/animation.gsap

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

  var controller = new ScrollMagic.Controller();

  var scene = new ScrollMagic.Scene({
    triggerElement: "#quero-usar-o-Dunno",
    duration: 200,
    triggerHook: "onLeave"
  }).addTo(controller);

  // build tween
  var tween = TweenMax.from("#animate", 0.5, {
    autoAlpha: 0,
    scale: 0.7
  });

  // change behaviour of controller to animate scroll instead of jump
  controller.scrollTo(function (newpos) {
    TweenMax.to(window, 2.5, {
      scrollTo: {
        y: newpos
      }
    });
  });

  //  bind scroll to anchor links
  $(document).on("click", ".invitation__link", function (e) {
    var id = $(this).attr("href");
    if ($(id).length > 0) {
      e.preventDefault();

      // trigger scroll
      controller.scrollTo(id);

      // if supported by the browser we can even update the URL.
      if (window.history && window.history.pushState) {
        history.pushState("", document.title, id);
      }
    }
  });
});

