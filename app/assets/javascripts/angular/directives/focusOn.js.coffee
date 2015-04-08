DunnoApp = angular.module('DunnoApp')

DunnoApp.directive 'focusOn', ->
  restrict: 'A'
  scope:
    focusOn: '='
  link: (scope, element, attr)->
    scope.$watch 'focusOn', (newValue) ->
      setTimeout((-> element.focus()), 0) if !!newValue
