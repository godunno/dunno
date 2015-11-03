courseFormCtrl = (
  Course,
  PageLoading,
  ErrorParser,
  $scope,
  $state,
  $templateCache
) ->
  vm = @

  vm.course ?= {}
  vm.startDate = moment(vm.course.start_date)
  vm.endDate = moment(vm.course.end_date || undefined)

  formatDate = (date) ->
    date?.format('YYYY-MM-DD') || null

  success = (course) ->
    $state.go('.', $state.params, reload: true)
    vm.onSave()(course)

  failure = (response) ->
    ErrorParser.setErrors(response.data.errors, vm.courseForm, $scope)

  vm.save = ->
    vm.course.start_date = formatDate(vm.startDate)
    vm.course.end_date = formatDate(vm.endDate) if vm.hasEndDate()
    vm.submitting = PageLoading.resolve(new Course(vm.course).save()).then(success, failure)

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
  'ErrorParser',
  '$scope',
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
