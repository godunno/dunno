courseFormCtrl = (Course, PageLoading, $state) ->
  @removeEndDate = ->
    @course.end_date = undefined

  @save = ->
    PageLoading.resolve(new Course(@course).save()).then (course) =>
      $state.go('.', null, reload: true)
      @onSave()(course)

  @

courseFormCtrl.$inject = [
  'Course',
  'PageLoading',
  '$state']

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
