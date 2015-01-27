DunnoApp = angular.module('DunnoApp')

DunnoApp.controller 'dropdownInputCtrl', ['$scope', 'Dropdown', ($scope, Dropdown)->
  $scope._close = Dropdown.close
]

DunnoApp.directive 'dropdownInput', ->
  restrict: 'A'
  controller: 'dropdownInputCtrl'
  link: (scope, element, attrs)->
    dropdown = element.parents("[data-dropdown-content]")
    dropdown.on "opened", -> element.focus()

    element.on "keypress", (event)->
      if event.keyCode == 13 # pressed "return"
        scope.$eval(attrs.dropdownInput)
        scope._close(dropdown)
        false
