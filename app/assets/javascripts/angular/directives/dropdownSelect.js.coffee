DunnoApp = angular.module('DunnoApp')

DunnoApp.controller 'dropdownSelectCtrl', ['$scope', 'Dropdown', ($scope, Dropdown)->
  $scope.setModelValue = (param)->
    $scope.model.$setViewValue(param)
    $scope.$apply()

    Dropdown.close($scope.element)
]

DunnoApp.directive 'dropdownSelect', ->
  require: 'ngModel'
  restrict: 'A'
  scope: true
  controller: 'dropdownSelectCtrl'
  link: (scope, element, attrs, ngModelCtrl)->
    scope.model = ngModelCtrl
    scope.element = element

DunnoApp.directive 'dropdownSelectItem', ->
  require: '^dropdownSelect'
  restrict: 'A'
  link: (scope, element, attrs, dropdownSelectCtrl)->
    element.click -> scope.setModelValue(attrs.dropdownSelectItem)
