DunnoApp = angular.module('DunnoApp')

prebootstrapLoading = ->
  restrict: 'A'
  link: (scope, element, attrs)->
    element.fadeOut(500, element.remove)

DunnoApp.directive 'prebootstrapLoading', prebootstrapLoading
