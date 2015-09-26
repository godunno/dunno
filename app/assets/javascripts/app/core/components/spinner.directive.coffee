spinner = ->
  restrict: 'E'
  templateUrl: 'core/components/spinner.directive'

angular
  .module('app.core')
  .directive('spinner', spinner)
