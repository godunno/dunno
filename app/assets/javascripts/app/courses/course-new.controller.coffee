NewCourseCtrl = (modalInstance, AnalyticsTracker) ->

  @trackAndClose = (course) ->
    AnalyticsTracker.courseCreated(course)
    modalInstance.destroy()

  @

NewCourseCtrl.$inject = ['modalInstance', 'AnalyticsTracker']

angular
  .module('app.courses')
  .controller('NewCourseCtrl', NewCourseCtrl)
