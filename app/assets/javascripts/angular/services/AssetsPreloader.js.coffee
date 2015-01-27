DunnoApp = angular.module('DunnoApp')

DunnoApp.service 'AssetsPreloader', ->

  container = $('<div>')
  container.css('position', 'absolute')
  container.css('visibility', 'hidden')
  $('body').append(container)

  @loadImage = (path)-> (new Image()).src = path

  @loadFont = (font)->
    p = $('<p>')
    p.text = ' '
    p.css('font-family', font)
    container.append(p)

  @
