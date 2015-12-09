CourseAnalyticsCtrl = ($scope, Course) ->
  vm = @

  vm.selectedPeriod = '1'

  vm.chartOptions =
    seriesBarDistance: 10,
    horizontalBars: true,
    axisY:
      offset: 70
    axisX:
      onlyInteger: true

  pluck = (field) ->
    (object) ->
      object[field]

  setChartData = ->
    return unless vm.members?

    vm.chartOptions.height = 50 * vm.members.length + 'px'

    field = vm.sortingOptions.field
    sortedMembers = vm.members.sort (a, b) ->
      (a[field] - b[field]) * if vm.sortingOptions.reverse then 1 else -1

    vm.chartData =
      labels: sortedMembers.map(pluck('name'))
      series: [sortedMembers.map(pluck(field))]

  fetch = (since) ->
    Course.$get($scope.course.$url('analytics'), since: since).then (members) ->
      vm.members = members

  $scope.$watch 'vm.selectedPeriod', (selectedPeriod) ->
    since = moment().subtract(parseInt(selectedPeriod), 'days')
    fetch(since).then(setChartData)

  $scope.$watch 'vm.sortingOptions.field', setChartData

  vm.average = (field, list) ->
    return 0 unless list?
    list.reduce(((acc, element) -> acc + element[field]), 0) / list.length

  vm.sortingOptions =
    field: 'course_accessed_events'
    reverse: true

  vm.sortBy = (field) ->
    if vm.sortingOptions.field == field
      vm.sortingOptions.reverse = !vm.sortingOptions.reverse
    else
      vm.sortingOptions.field = field
    setChartData()

  vm

CourseAnalyticsCtrl.$inject = ['$scope', 'Course']

angular
  .module('app.courses')
  .controller('CourseAnalyticsCtrl', CourseAnalyticsCtrl)
