EditEventDatesCtrl = ($state, modalInstance, PageLoading, event) ->
  vm = @
  vm.event = event
  vm.date = moment(event.start_at)
  vm.startTime = moment(event.start_at)
  vm.endTime = moment(event.end_at)

  # Due to jquery-timepicker only working a function
  # for the durationTime option.
  vm.getStartTime = -> vm.startTime

  timeAt = (date, time) ->
    moment(time)
      .date(date.date())
      .month(date.month())
      .year(date.year())

  vm.save = ->
    vm.event.start_at = timeAt(vm.date, vm.startTime).toISOString()
    vm.event.end_at = timeAt(vm.date, vm.endTime).toISOString()
    vm.submitting = PageLoading.resolve(vm.event.save()).then (event) ->
      params = angular.extend({}, $state.params, startAt: event.start_at)
      $state.go('.', params)
      modalInstance.destroy()

  vm

EditEventDatesCtrl.$inject = ['$state', 'modalInstance', 'PageLoading', 'event']

angular
  .module('app.lessonPlan')
  .controller('EditEventDatesCtrl', EditEventDatesCtrl)
