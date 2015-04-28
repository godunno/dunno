DunnoApp = angular.module("DunnoApp")

editInPlace = ->
  restrict: 'A'
  require: 'ngModel'
  scope:
    onSuccess: '&'
  link: (scope, element, attrs, ngModelCtrl) ->
    originalValue = ngModelCtrl.$modelValue
    element.focus ->
      originalValue = ngModelCtrl.$modelValue

    rollback = ->
      ngModelCtrl.$setViewValue(originalValue)
      ngModelCtrl.$render()

    element.blur (e) ->
      if ngModelCtrl.$invalid
        rollback()
      scope.onSuccess()

    element.on 'keydown', (e) ->
      esc = e.keyCode == 27
      enter = e.keyCode == 13

      if esc
        rollback()
        element.blur()

      if enter && ngModelCtrl.$valid
        element.blur()
        e.preventDefault()

DunnoApp.directive "editInPlace", editInPlace
