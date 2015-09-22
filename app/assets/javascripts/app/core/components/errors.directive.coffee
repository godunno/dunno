ErrorsController = ($scope, ErrorsRepository) ->
  throw new Error("Errors must have a for attribute.") unless $scope.translationKey?
  $scope.errors = ->
    ErrorsRepository.getErrorsFor($scope.translationKey)

ErrorsController.$inject = ['$scope', 'ErrorsRepository']

errors = ->
  restrict: 'E'
  controller: ErrorsController
  controllerAs: 'vm'
  templateUrl: 'core/components/errors.directive'
  scope:
    translationKey: '@for'

angular
  .module('app.core')
  .directive('errors', errors)
