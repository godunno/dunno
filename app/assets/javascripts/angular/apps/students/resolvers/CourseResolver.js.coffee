DunnoAppStudent = angular.module('DunnoAppStudent')

resolver = ($route, PageLoading, Course) ->
  PageLoading.resolve Course.get(access_code: $route.current.params.id)

resolver.$inject = ['$route', 'PageLoading', 'Course']
DunnoAppStudent.constant 'CourseResolver', resolver
