DunnoApp = angular.module('DunnoApp')

DunnoApp.service 'DeviceDetector', ->
  @width = -> window.innerWidth || document.documentElement.clientWidth || document.body.clientWidth
  @isMobile = -> @width() < 768
  @
