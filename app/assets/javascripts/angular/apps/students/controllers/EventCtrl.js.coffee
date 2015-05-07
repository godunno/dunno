DunnoAppStudent = angular.module('DunnoAppStudent')

EventCtrl = ($scope, $routeParams, event)->
  $scope.event = event

EventCtrl.$inject = ['$scope', '$routeParams', 'event']
DunnoAppStudent.controller 'EventCtrl', EventCtrl
