DunnoApp = angular.module('DunnoApp')

DunnoApp.directive 'datepicker', ->
  restricted: 'A'
  link: (scope, element)->
    element.datepicker(format: 'dd/mm/yyyy')
