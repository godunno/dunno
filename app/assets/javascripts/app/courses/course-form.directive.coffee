courseFormCtrl = (
  Course,
  PageLoading,
  $state,
  $templateCache
) ->
  vm = @

  vm.course ?= { start_date: moment(), end_date: moment() }
  vm.startDate = vm.course.start_date
  vm.endDate = vm.course.end_date

  vm.removeEndDate = ->
    vm.course.end_date = undefined

  vm.save = ->
    vm.submitting = PageLoading.resolve(new Course(vm.course).save()).then (course) ->
      $state.go('.', null, reload: true)
      vm.onSave()(course)

  formatDate = (date) ->
    date.format('YYYY-MM-DD')

  datepickerTemplate =  $templateCache.get('courses/datepicker-for-course-form')

  vm.startDateOptions =
    template: datepickerTemplate
    callback: (date) ->
      vm.course.start_date = formatDate(date)

  vm.endDateOptions =
    template: datepickerTemplate
    callback: (date) ->
      vm.course.end_date = formatDate(date)

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
