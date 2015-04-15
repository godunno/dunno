# http://blog.somewhatabstract.com/2014/06/15/navigation-guard-using-angularjs-onbeforeunload/#rf1-1979

DunnoApp = angular.module('DunnoApp')

DunnoApp.factory "NavigationGuard", ['$window', '$rootScope', ($window, $rootScope)->

  guardians = []

  onBeforeUnloadHandler = (event)->
    if message = confirmMessage()
      (event or $window.event).returnValue = message
      message

  exitHandler = (event)->
    if message = confirmMessage()
      if !confirm(message)
        event.preventDefault()

  confirmMessage = ->
    for guardian in guardians
      message = guardian()
      return message if message

  if $window.addEventListener
    $window.addEventListener "beforeunload", onBeforeUnloadHandler
  else
    $window.onbeforeunload = onBeforeUnloadHandler

  # https://github.com/angular/angular.js/issues/2109
  $rootScope.$on('$locationChangeStart', exitHandler)
  $rootScope.$on('dunno.exit', exitHandler)

  registerGuardian = (guardianCallback)->
    guardians.unshift guardianCallback

  unregisterGuardian = (guardianCallback)->
    index = guardians.indexOf(guardianCallback)
    guardians.splice index, 1  if index >= 0

  {
    registerGuardian: registerGuardian
    unregisterGuardian: unregisterGuardian
  }
]
