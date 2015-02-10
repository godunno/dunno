DunnoApp = angular.module('DunnoApp')

EventsIndexCtrl = ($scope, Event, $location, $routeParams, DateUtils)->
  angular.extend($scope, DateUtils)

  $scope.$emit('wholePageLoading', Event.query().then (events)->
    $scope.events = events
  )

EventsIndexCtrl.$inject = ['$scope', 'Event', '$location', '$routeParams', 'DateUtils']
DunnoApp.controller 'EventsIndexCtrl', EventsIndexCtrl
