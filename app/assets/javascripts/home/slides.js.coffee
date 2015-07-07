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
    duration: 600
  .setTween(animationEffects)

setupSlides()
