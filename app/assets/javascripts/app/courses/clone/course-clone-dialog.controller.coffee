CloneCourseDialogCtrl = (
  modalInstance,
  $templateCache,
  $state,
  $window,
  AnalyticsTracker,
  course
) ->
  vm = @

  window.$window = $window

  vm.course = course
  vm.startDate = moment(vm.course.start_date)
  vm.endDate = moment(vm.course.end_date || undefined)

  formatDate = (date) ->
    date?.format('YYYY-MM-DD') || null

  datepickerTemplate =  $templateCache.get('courses/datepicker-for-course-form')

  vm.calendarOptions =
    template: datepickerTemplate

  hasEndDate = vm.course.end_date?
  vm.hasEndDate = -> hasEndDate
  vm.addEndDate = -> hasEndDate = true
  vm.removeEndDate = ->
    vm.endDate = undefined
    hasEndDate = false

  vm.trackAndClose = (course) ->
    AnalyticsTracker.courseCloned(course)
    modalInstance.destroy()

  vm.clone = ->
    vm.course.start_date = formatDate(vm.startDate)
    vm.course.end_date = formatDate(vm.endDate) if vm.hasEndDate()
    vm.cloneLink = $window.location.origin + $window.location.pathname + $state.href(
      'app.courses.clone-confirm',
      {
        courseId: course.access_code,
        name: course.name,
        startDate: vm.course.start_date,
        endDate: vm.course.end_date
      }
    )

  vm

CloneCourseDialogCtrl.$inject = [
  'modalInstance',
  '$templateCache',
  '$state',
  '$window',
  'AnalyticsTracker',
  'course'
]

angular
  .module('app.courses')
  .controller('CloneCourseDialogCtrl', CloneCourseDialogCtrl)
