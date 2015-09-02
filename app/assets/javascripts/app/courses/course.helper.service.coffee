CourseHelper = ->
  isTeacher = (course) ->
    course.user_role == 'teacher'

  isStudent = (course) ->
    course.user_role != 'teacher'

  return {
    isTeacher: isTeacher
    isStudent: isStudent
  }

angular
  .module('DunnoApp')
  .factory('CourseHelper', CourseHelper)
