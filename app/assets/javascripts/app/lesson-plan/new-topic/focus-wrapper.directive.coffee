DunnoApp = angular.module('DunnoApp')

DunnoApp.directive 'focusWrapper', ->
  restricted: 'A'
  link: (scope, element, attrs)->
    element.on 'focus', ->
      element.parent().addClass('focus-wrapper')

    element.on 'blur', ->
      element.parent().removeClass('focus-wrapper')

