DunnoApp = angular.module('DunnoApp')

DunnoApp.directive 'slideOn', ->
  restrict: 'A'
  link: (scope, element, attr)->
    scope.$watch attr.slideOn, (newValue) ->
      if !!newValue
        element.slideDown()
      else
        element.slideUp()
