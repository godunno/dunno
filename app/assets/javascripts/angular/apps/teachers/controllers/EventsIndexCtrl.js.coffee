DunnoApp = angular.module('DunnoApp')

EventsIndexCtrl = ($scope, events, Event, DateUtils)->
  angular.extend($scope, DateUtils)
  $scope.events = events
  $scope.eventsOffset = events.length
  $scope.nextPage = 1

  $scope.paginate = (page) ->
    Event.query(course_id: $scope.course.uuid, offset: $scope.eventsOffset, page: page).then (events) ->
      $scope.events = ($scope.events || []).concat events
      $scope.nextPage = page + 1
      $scope.noMoreEvents = true if events.length == 0

EventsIndexCtrl.$inject = ['$scope', 'events', 'Event', 'DateUtils']
DunnoApp.controller 'EventsIndexCtrl', EventsIndexCtrl
