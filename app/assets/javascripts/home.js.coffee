#= require jquery
#= require foundation/foundation
#= require foundation/foundation.topbar
#= require foundation/foundation.reveal
#= require wow
#= require greensock
#= require greensock/plugins/ScrollToPlugin
#= require scrollmagic
#= require scrollmagic/plugins/animation.gsap

focusField = (element) ->
  $(element).focus()
  return

$ ->
  $(document).foundation
    topbar: start_offset: 140
  # TODO: convert to function
  # TODO: add slider behaviour (automatic switching)
  # TODO: add wow animated effect on change
  $('.feature').on 'click', (e) ->
    e.preventDefault()
    _self = $(this)
    index = _self.data('feature')
    if !_self.hasClass('active')
      $('.feature.active').removeClass 'active'
      $(this).toggleClass 'active'
      $('#features__screenshot').removeClass().addClass 'features__screenshot showing__feature__' + index
    return
  wow = new WOW(
    boxClass: 'wow'
    animateClass: 'animated'
    offset: 450
    mobile: true
    live: true)
  wow.init()
  controller = new (ScrollMagic.Controller)(globalSceneOptions: triggerHook: 'onLeave')
  slides = document.querySelectorAll('section.slide__section')
  i = 0
  while i < slides.length
    new (ScrollMagic.Scene)(triggerElement: slides[i]).setPin(slides[i]).addTo controller
    i++
  $(document).on 'click', '.invitation__link', (e) ->
    id = $(this).attr('href')
    if $(id).length > 0
      e.preventDefault()
      focusField('#invitation__email')
      if window.history and window.history.pushState
        history.pushState '', document.title, id
    return
  return
