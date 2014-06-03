DunnoApp = angular.module('DunnoApp')

DunnoApp.directive 'timepicker', ->
  restricted: 'A'
  link: (scope, element)->
    element.timepicker()
