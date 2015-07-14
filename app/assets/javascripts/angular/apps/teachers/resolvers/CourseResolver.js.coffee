DunnoApp = angular.module('DunnoApp')

resolver = ($stateParams, PageLoading, Course) ->
  PageLoading.resolve Course.get({ uuid: $stateParams.courseId}, {month: $stateParams.month })

resolver.$inject = ['$stateParams', 'PageLoading', 'Course']
DunnoApp.constant 'CourseResolver', resolver
