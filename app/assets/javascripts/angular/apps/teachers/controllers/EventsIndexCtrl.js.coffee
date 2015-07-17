DunnoApp = angular.module('DunnoApp')

EventsIndexCtrl = ($scope, $stateParams, events, DateUtils)->
  angular.extend($scope, DateUtils)
  $scope.events = events

EventsIndexCtrl.$inject = ['$scope', '$stateParams', 'events', 'DateUtils']
DunnoApp.controller 'EventsIndexCtrl', EventsIndexCtrl
