submitButton = ->
  SubmitButtonController = ($scope) ->
    $scope.$watch 'blockedWhen', (promise) ->
      return unless promise?
      $scope.blocked = true
      promise.finally -> $scope.blocked = false

  SubmitButtonController.$inject = ['$scope']

  restrict: 'E'
  replace: true
  scope:
    blockedWhen: '='
    blockedLabel: '@'
    label: '@'
  templateUrl: 'core/components/submit-button.directive'
  controller: SubmitButtonController
  link: (scope, element, attrs) ->
    scope.hasSpinner = attrs.hasSpinner?

angular
  .module('app.core')
  .directive('submitButton', submitButton)
