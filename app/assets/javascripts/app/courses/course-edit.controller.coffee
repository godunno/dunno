EditCourseCtrl = (course) ->
  @course = course

  @

EditCourseCtrl.$inject = ['course']

angular
  .module('app.courses')
  .controller('EditCourseCtrl', EditCourseCtrl)
