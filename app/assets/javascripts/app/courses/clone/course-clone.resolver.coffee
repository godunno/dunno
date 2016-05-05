resolver = ($stateParams, PageLoading, Course) ->
  PageLoading.resolve Course.search($stateParams.courseId, skip_authorization: true)

resolver.$inject = ['$stateParams', 'PageLoading', 'Course']

angular
  .module('app.courses')
  .constant 'CourseCloneResolver', resolver
