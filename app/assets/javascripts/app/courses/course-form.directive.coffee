courseFormCtrl = (
  Course,
  PageLoading,
  $state,
  $templateCache
) ->
  vm = @

  vm.course ?= {}
  vm.startDate = moment(vm.course.start_date)
  vm.endDate = moment(vm.course.end_date || undefined)

  formatDate = (date) ->
    date?.format('YYYY-MM-DD') || null

  vm.save = ->
    vm.course.start_date = formatDate(vm.startDate)
    vm.course.end_date = formatDate(vm.endDate)
    vm.submitting = PageLoading.resolve(new Course(vm.course).save()).then (course) ->
      $state.go('.', null, reload: true)
      vm.onSave()(course)

  datepickerTemplate =  $templateCache.get('courses/datepicker-for-course-form')

  vm.calendarOptions =
    template: datepickerTemplate

  hasEndDate = vm.course.end_date?
  vm.hasEndDate = -> hasEndDate
  vm.addEndDate = -> hasEndDate = true
  vm.removeEndDate = ->
    vm.endDate = undefined
    hasEndDate = false

  vm

courseFormCtrl.$inject = [
  'Course',
  'PageLoading',
  '$state',
  '$templateCache'
]

courseForm = ->
  templateUrl: 'courses/course-form.directive'
  controller: courseFormCtrl
  controllerAs: 'vm'
  bindToController: true
  scope:
    course: '=?'
    submitLabel: '@'
    onSave: '&'

angular
  .module('app.courses')
  .directive('courseForm', courseForm)
