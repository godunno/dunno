DunnoApp = angular.module("DunnoApp")

editInPlace = ->
  restrict: 'A'
  require: 'ngModel'
  link: (scope, element, attrs, ngModelCtrl)->
    ngModelCtrl.$$setOptions updateOn: 'updateModel', debounce: 0
    element.blur -> ngModelCtrl.$rollbackViewValue()
    element.on 'keydown', (e)->
      esc = e.keyCode == 27
      enter = e.keyCode == 13
      if esc
        element.blur()
      if enter
        element.trigger('updateModel')
        element.blur()
        e.preventDefault() if e.preventDefault?
        e.stopPropagation() if e.stopPropagation?
        return false

DunnoApp.directive "editInPlace", editInPlace
