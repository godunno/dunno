DunnoAppStudent = angular.module('DunnoAppStudent')

EventCtrl = ($scope, $routeParams, Event)->
  if $routeParams.id
    Event.get(uuid: $routeParams.id).then (event)->
      $scope.event = event

EventCtrl.$inject = ['$scope', '$routeParams', 'Event']
DunnoAppStudent.controller 'EventCtrl', EventCtrl
