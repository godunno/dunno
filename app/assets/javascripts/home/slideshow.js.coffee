$ ->
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


  setupScreenshots()
