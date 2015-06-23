DunnoApp = angular.module('DunnoApp')

resolver = ($route, PageLoading, Course) ->
  PageLoading.resolve Course.search($route.current.params.id)

resolver.$inject = ['$route', 'PageLoading', 'Course']
DunnoApp.constant 'CourseRegistrationResolver', resolver
