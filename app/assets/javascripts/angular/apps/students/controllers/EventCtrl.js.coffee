DunnoAppStudent = angular.module('DunnoAppStudent')

EventCtrl = ($scope, $routeParams, Event)->
  if $routeParams.id
    $scope.$emit 'wholePageLoading',
    Event.get(uuid: $routeParams.id).then (event) ->
      $scope.event = event

DunnoAppStudent.controller 'EventCtrl', EventCtrl
