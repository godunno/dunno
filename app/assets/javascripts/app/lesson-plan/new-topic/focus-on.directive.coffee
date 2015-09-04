focusOn = ($timeout) ->
  link = (scope, element, attrs) ->
    scope.$watch attrs.focusOn, (newValue) ->
      $timeout(-> element.focus()) if !!newValue

  restrict: 'A'
  link: link

focusOn.$inject = ['$timeout']

angular
  .module('app.lessonPlan')
  .directive('focusOn', focusOn)
