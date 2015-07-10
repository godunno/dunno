DunnoApp = angular.module('DunnoApp')

CourseEventsCtrl = ($scope, $stateParams, events, Event, DateUtils)->
  angular.extend($scope, DateUtils)
  $scope.events = events
  $scope.eventsOffset = events.length
  $scope.nextPage = 1
  $scope.scrollUntil = $stateParams.until

  $scope.paginate = (page) ->
    Event.query(course_id: $scope.course.uuid, offset: $scope.eventsOffset, page: page).then (events) ->
      $scope.events = ($scope.events || []).concat events
      $scope.nextPage = page + 1
      $scope.noMoreEvents = true if events.length == 0

CourseEventsCtrl.$inject = ['$scope', '$stateParams', 'events', 'Event', 'DateUtils']
DunnoApp.controller 'CourseEventsCtrl', CourseEventsCtrl
