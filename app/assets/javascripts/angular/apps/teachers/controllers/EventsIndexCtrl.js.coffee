DunnoApp = angular.module('DunnoApp')

EventsIndexCtrl = ($scope, Event, $location, $routeParams, DateUtils) ->
  angular.extend($scope, DateUtils)

  $scope.$emit 'wholePageLoading', Event.query().then (events) ->
    $scope.events = events

DunnoApp.controller 'EventsIndexCtrl', EventsIndexCtrl
