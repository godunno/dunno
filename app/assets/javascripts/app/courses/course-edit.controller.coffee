EditCourseCtrl = (modalInstance, course) ->
  @course = course

  @close = ->
    modalInstance.destroy()

  @

EditCourseCtrl.$inject = ['modalInstance', 'course']

angular
  .module('app.courses')
  .controller('EditCourseCtrl', EditCourseCtrl)
