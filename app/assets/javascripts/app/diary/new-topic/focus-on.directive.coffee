DunnoApp = angular.module('DunnoApp')

DunnoApp.directive 'focusOn', ['$timeout', ($timeout) ->
  restrict: 'A'
  link: (scope, element, attr)->
    scope.$watch attr.focusOn, (newValue) ->
      $timeout(-> element.focus()) if !!newValue
]