EditCourseCtrl = (modalInstance, AnalyticsTracker, course) ->
  @course = course

  @trackAndClose = (course) ->
    AnalyticsTracker.courseEdited(course)
    modalInstance.destroy()

  @

EditCourseCtrl.$inject = ['modalInstance', 'AnalyticsTracker', 'course']

angular
  .module('app.courses')
  .controller('EditCourseCtrl', EditCourseCtrl)
