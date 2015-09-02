EditCourseCtrl = (course) ->
  @course = course

  @

EditCourseCtrl.$inject = ['course']

angular
  .module('DunnoApp')
  .controller('EditCourseCtrl', EditCourseCtrl)
