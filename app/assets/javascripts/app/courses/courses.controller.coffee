CoursesIndexCtrl = ($location, $filter, ModalFactory, Utils, courses) ->
  @courses = courses

  @activeCourses   = @courses.filter (course) -> course.active
  @inactiveCourses = @courses.filter (course) -> !course.active

  @openNewCourseForm = ->
    new ModalFactory
      templateUrl: 'courses/course-new'
      controller: 'NewCourseCtrl'
      class: 'medium course__new'
      controllerAs: 'vm'
      bindToController: true
    .activate()

  @

CoursesIndexCtrl.$inject = ['$location', '$filter', 'ModalFactory', 'Utils', 'courses']

angular
  .module('app.courses')
  .controller('CoursesIndexCtrl', CoursesIndexCtrl)
