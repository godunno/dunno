DunnoApp = angular.module('DunnoApp')

DunnoApp.controller 'dropdownInputCtrl', ($scope, Dropdown) ->
  $scope._close = Dropdown.close


DunnoApp.directive 'dropdownInput', ->
  restrict: 'A'
  controller: 'dropdownInputCtrl'
  link: (scope, element, attrs) ->
    dropdown = element.parents("[data-dropdown-content]")
    dropdown.on "opened", ->
      scope.$eval(attrs.onOpen)
      element.select()

    element.on "keypress", (event) ->
      if event.keyCode == 13 # pressed "return"
        scope.$eval(attrs.onClose)
        scope._close(dropdown)
        false
