DunnoApp = angular.module('DunnoApp')

ScheduleCtrl = ($scope) ->
  $scope.weekly_schedules = ({ weekday: i } for i in [1, 2, 3, 4, 5, 6, 0])

ScheduleCtrl.$inject = ['$scope']
DunnoApp.controller 'ScheduleCtrl', ScheduleCtrl
