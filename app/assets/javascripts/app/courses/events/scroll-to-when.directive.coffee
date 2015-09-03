link = (scope, element, attrs) ->
  scope.$watch attrs.scrollToWhen, (newValue) ->
    $('html,body').animate(scrollTop: element.offset().top) if !!newValue

scrollToWhen = ->
  link: link
  restrict: 'A'

angular
  .module('app.courses')
  .directive('scrollToWhen', scrollToWhen)
