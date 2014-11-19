DunnoApp = angular.module("DunnoApp")

editInPlace = ->
  restrict: 'A'
  link: (scope, element, attrs)->
    element.on 'keydown', (e)->
      esc = e.keyCode == 27
      enter = e.keyCode == 13
      if esc
        document.execCommand("undo")
        element.blur()
      if enter
        element.blur()
        e.preventDefault() if e.preventDefault?
        e.stopPropagation() if e.stopPropagation?
        return false

DunnoApp.directive "editInPlace", editInPlace
