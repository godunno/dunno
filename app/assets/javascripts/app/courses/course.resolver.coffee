CourseResolver = ($stateParams, PageLoading, Course) ->
  PageLoading.resolve Course.get({ uuid: $stateParams.courseId }, { month: $stateParams.month })

CourseResolver.$inject = ['$stateParams', 'PageLoading', 'Course']

angular
  .module('app.core')
  .constant('CourseResolver', CourseResolver)
