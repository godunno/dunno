DunnoApp = angular.module("DunnoApp")

editInPlace = ->
  restrict: 'A'
  require: 'ngModel'
  scope:
    onFinish: '&'
  link: (scope, element, attrs, ngModelCtrl)->
    ngModelCtrl.$$setOptions updateOn: 'blur', debounce: 0
    element.on 'keydown', (e)->
      esc = e.keyCode == 27
      enter = e.keyCode == 13
      if esc
        ngModelCtrl.$rollbackViewValue()
        element.blur()
      if enter
        element.blur()
        scope.onFinish()
        e.preventDefault()

DunnoApp.directive "editInPlace", editInPlace
