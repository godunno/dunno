DunnoApp = angular.module('DunnoApp')

DunnoApp.directive 'focusOn', ->
  restrict: 'A'
  link: (scope, element, attr)->
    scope.$watch attr.focusOn, (newValue) ->
      setTimeout((-> element.focus()), 0) if !!newValue
