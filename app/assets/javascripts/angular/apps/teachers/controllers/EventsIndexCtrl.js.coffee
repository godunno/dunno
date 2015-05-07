DunnoApp = angular.module('DunnoApp')

EventsIndexCtrl = ($scope, events, DateUtils)->
  angular.extend($scope, DateUtils)
  $scope.events = events

EventsIndexCtrl.$inject = ['$scope', 'events', 'DateUtils']
DunnoApp.controller 'EventsIndexCtrl', EventsIndexCtrl
