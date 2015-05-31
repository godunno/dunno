# http://blog.somewhatabstract.com/2014/06/15/navigation-guard-using-angularjs-onbeforeunload/#rf1-1979

DunnoApp = angular.module('DunnoApp')
DunnoAppStudent = angular.module('DunnoAppStudent')

NavigationGuard = ($window, $rootScope) ->

  edits = 0
  reset = -> edits = 0
  startEditing = ->
    edits++
  finishEditing = ->
    edits--

  guard = ->
    $rootScope.$on('startEditing', startEditing)
    $rootScope.$on('finishEditing', finishEditing)

  onBeforeUnloadHandler = (event) ->
    if message = confirmMessage()
      (event or $window.event).returnValue = message
      message

  exitHandler = (event)->
    if message = confirmMessage()
      if confirm(message)
        reset()
      else
        event.preventDefault()

  confirmMessage = ->
    return "Existem conteúdos que não foram inseridos na aula ainda." if edits > 0

  if $window.addEventListener
    $window.addEventListener "beforeunload", onBeforeUnloadHandler
  else
    $window.onbeforeunload = onBeforeUnloadHandler

  # https://github.com/angular/angular.js/issues/2109
  $rootScope.$on('$locationChangeStart', exitHandler)
  $rootScope.$on('dunno.exit', exitHandler)

  {
    guard: guard
  }

NavigationGuard.$inject = ['$window', '$rootScope']

DunnoApp.factory "NavigationGuard", NavigationGuard
DunnoAppStudent.factory "NavigationGuard", NavigationGuard
