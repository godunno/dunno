DunnoApp = angular.module('DunnoApp')

DunnoApp.directive 'scrollToWhen', ->
  restrict: 'A'
  link: (scope, element, attr)->
    scope.$watch attr.scrollToWhen, (newValue) ->
      $('html,body').animate(scrollTop: element.offset().top) if !!newValue
