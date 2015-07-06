#= require jquery
#= require foundation/foundation
#= require foundation/foundation.topbar
#= require foundation/foundation.reveal
#= require greensock
#= require greensock/plugins/ScrollToPlugin
#= require scrollmagic
#= require scrollmagic/plugins/animation.gsap

$ ->
  setupFoundationAndTopBar()
  setupScreenshots()
  setupSlides()

setupFoundationAndTopBar = ->
  $(document).foundation
    topbar:
      start_offset: 140
      sticky_on: 'medium, large'

setupScreenshots = ->
  screenshotsLoop = loopScreenshots()

  $('.feature__item > a').on 'click', (e) ->
    e.preventDefault()

    clearInterval(screenshotsLoop)
    activateFeature($(this).parent())

activateFeature = (el) ->
  featureLink = $(el).find('a')

  index = featureLink.data('feature')

  $('.feature__item .active').removeClass 'active'
  featureLink.addClass 'active'

  $('#features__screenshot')
  .removeClass()
  .addClass 'features__screenshot showing__feature__' + index

loopScreenshots = ->
  setInterval ->
    features = $('.feature__item')
    activeFeature = $('.feature__item').has('.active')

    if activeFeature.is(':last-child')
      activateFeature(features.first())
    else
      activateFeature(activeFeature.next())
  , 3000

setupSlides = ->
  controller = new ScrollMagic.Controller()
  slides = document.querySelectorAll('section.slide__section')

  for slide in slides
    scene = setupScene(slide)
    controller.addScene(scene)

setupScene = (slide) ->
  animationEffects = new TimelineLite()
  .fromTo(
    slide.querySelector('.slide__image'),
    .5,
    { x: 1000, force3D: true },
    { x: 0 }
  )
  .to(
    slide.querySelector('.slide__content'),
    1,
    { force3D: true, opacity: 1 }
    , 0
  )

  new ScrollMagic.Scene
    triggerElement: slide
    duration: 500
  .setTween(animationEffects)


$(document).on 'click', '.invitation__link', (e) ->
  id = $(this).attr('href')
  if $(id).length > 0
    e.preventDefault()
    $('#invitation__email').focus()
    if window.history and window.history.pushState
      history.pushState '', document.title, id
