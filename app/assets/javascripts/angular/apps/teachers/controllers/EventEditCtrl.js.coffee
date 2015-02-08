DunnoApp = angular.module('DunnoApp')

EventEditCtrl = ($scope) ->
  $scope.editingItem = {}

DunnoApp.controller 'EventEditCtrl', EventEditCtrl
