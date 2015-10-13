scrollToWhen = ($timeout) ->
  link = (scope, element, attrs) ->
    scope.$watch attrs.scrollToWhen, (newValue) ->
      if !!newValue
        $timeout(-> element[0].scrollIntoView())

  link: link
  restrict: 'A'

scrollToWhen.$inject = ['$timeout']

angular
  .module('app.courses')
  .directive('scrollToWhen', scrollToWhen)
