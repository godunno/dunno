DunnoApp = angular.module('DunnoApp')

resolver = ($route, PageLoading, Course) ->
  PageLoading.resolve Course.get(uuid: $route.current.params.id)

resolver.$inject = ['$route', 'PageLoading', 'Course']
DunnoApp.constant 'CourseResolver', resolver
