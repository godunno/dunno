CourseAnalyticsCtrl = ($scope, Course) ->
  vm = @

  vm.selectedPeriod = '1'

  fetch = (since) ->
    Course.$get($scope.course.$url('analytics'), since: since).then (members) ->
      vm.members = members

  $scope.$watch 'vm.selectedPeriod', (selectedPeriod) ->
    since = moment().subtract(parseInt(selectedPeriod), 'days')
    fetch(since)

  vm.average = (field, list) ->
    return 0 unless list?
    list.reduce(((acc, element) -> acc + element[field]), 0) / list.length

  vm.sortingOptions =
    field: 'course_accessed_events'
    reversed: true

  vm.sortBy = (field) ->
    if vm.sortingOptions.field == field
      vm.sortingOptions.reverse = !vm.sortingOptions.reverse
    else
      vm.sortingOptions.field = field

  vm

CourseAnalyticsCtrl.$inject = ['$scope', 'Course']

angular
  .module('app.courses')
  .controller('CourseAnalyticsCtrl', CourseAnalyticsCtrl)
