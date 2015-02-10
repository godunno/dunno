DunnoApp = angular.module('DunnoApp')
DunnoAppStudent = angular.module('DunnoAppStudent')

prebootstrapLoading = ->
  restrict: 'A'
  link: (scope, element, attrs)->
    element.fadeOut(500, element.remove)

DunnoApp.directive 'prebootstrapLoading', prebootstrapLoading
DunnoAppStudent.directive 'prebootstrapLoading', prebootstrapLoading
