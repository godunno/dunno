DunnoAppStudent = angular.module('DunnoAppStudent')

EventCtrl = ($scope, $routeParams, Event)->
  if $routeParams.id
    $scope.$emit('wholePageLoading', Event.get(uuid: $routeParams.id).then (event)->
      $scope.event = event
    )

EventCtrl.$inject = ['$scope', '$routeParams', 'Event']
DunnoAppStudent.controller 'EventCtrl', EventCtrl
