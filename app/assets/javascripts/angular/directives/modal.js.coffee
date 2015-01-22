DunnoApp = angular.module('DunnoApp')

DunnoApp.directive 'modal', ->
  restrict: 'A'
  link: (scope, element, attr)->
    scope.dismiss = ->
      element.foundation('reveal', 'close')
      true
    scope.$on("modal.dismiss", scope.dismiss)
