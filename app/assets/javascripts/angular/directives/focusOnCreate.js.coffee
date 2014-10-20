DunnoApp = angular.module('DunnoApp')

DunnoApp.directive 'focusOnCreate', ->
  restrict: 'A'
  link: (scope, element, attr)->
    element.focus()
