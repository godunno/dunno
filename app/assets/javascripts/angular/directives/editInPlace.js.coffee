DunnoApp = angular.module("DunnoApp")

editInPlace = ($parse) ->
  restrict: 'A'
  require: 'ngModel'
  link: (scope, element, attrs, ngModelCtrl)->
    onFinish = $parse(attrs.onFinish)
    ngModelCtrl.$$setOptions updateOn: 'blur', debounce: 0
    element.on 'keydown', (e)->
      esc = e.keyCode == 27
      enter = e.keyCode == 13
      if esc
        ngModelCtrl.$rollbackViewValue()
        element.blur()
      if enter
        element.blur()
        onFinish(scope)
        e.preventDefault() if e.preventDefault?
        e.stopPropagation() if e.stopPropagation?
        return false

editInPlace.$inject = ['$parse']

DunnoApp.directive "editInPlace", editInPlace
