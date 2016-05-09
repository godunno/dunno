selectOn = ($timeout) ->
  link = (scope, element, attrs) ->
    scope.$watch attrs.selectOn, (newValue) ->
      $timeout(-> element.select()) if !!newValue

  restrict: 'A'
  link: link

selectOn.$inject = ['$timeout']

angular
  .module('app.courses')
  .directive('selectOn', selectOn)
