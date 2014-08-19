DunnoApp = angular.module('DunnoApp')

DunnoApp.directive 'mask', ->
  restricted: 'A'
  link: (scope, element, attrs)->
    $(element).mask(attrs.mask)
