DunnoApp = angular.module('DunnoApp')

EventEditCtrl = ($scope)->
  $scope.editingItem = {}

EventEditCtrl.$inject = ['$scope']
DunnoApp.controller 'EventEditCtrl', EventEditCtrl
