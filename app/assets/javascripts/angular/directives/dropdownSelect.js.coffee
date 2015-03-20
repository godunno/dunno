DunnoApp = angular.module('DunnoApp')

DunnoApp.controller 'dropdownSelectCtrl', ['$scope', 'Dropdown', ($scope, Dropdown)->
  model = -> $scope.element.find('.model').data().$ngModelController
  $scope.setModelValue = (param)->
    model().$setViewValue(param)
    $scope.$apply()

    Dropdown.close($scope.element)
]

DunnoApp.directive 'dropdownSelect', ->
  restrict: 'A'
  scope: true
  controller: 'dropdownSelectCtrl'
  link: (scope, element, attrs)->
    scope.element = element

DunnoApp.directive 'dropdownSelectItem', ['$parse', ($parse)->
  require: '^dropdownSelect'
  restrict: 'A'
  link: (scope, element, attrs, dropdownSelectCtrl)->
    element.click -> scope.setModelValue($parse(attrs.dropdownSelectItem)())
]
