courseLink = ->
  courseLinkCtrl = (AnalyticsTracker) ->
    @track = =>
      AnalyticsTracker.courseAccessed(@course, @page)

  courseLinkCtrl.$inject = ['AnalyticsTracker']

  controller: courseLinkCtrl
  controllerAs: 'vm'
  templateUrl: 'core/components/course-link.directive'
  scope:
    course: '='
    page: '@?'
  bindToController: true
  transclude: true
  restrict: 'E'

angular
  .module('app.core')
  .directive('courseLink', courseLink)
