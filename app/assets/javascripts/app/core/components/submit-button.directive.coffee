submitButton = ->
  SubmitButtonController = ($scope) ->
    $scope.$watch 'blockedWhen', (promise) ->
      return unless promise?
      $scope.blocked = true
      promise.finally -> $scope.blocked = false

  SubmitButtonController.$inject = ['$scope']

  moveAttributes = (element, attributes...) ->
    target = element.find('button')
    attributes.forEach (attr) ->
      value = element.attr(attr)
      element.removeAttr(attr)
      target.attr(attr, value)

  restrict: 'E'
  scope:
    blockedWhen: '='
    blockedLabel: '@'
    label: '@'
  templateUrl: 'core/components/submit-button.directive'
  controller: SubmitButtonController
  link: (scope, element, attrs) ->
    scope.hasSpinner = attrs.hasSpinner?
    moveAttributes(element, 'class', 'tabindex')

angular
  .module('app.core')
  .directive('submitButton', submitButton)
