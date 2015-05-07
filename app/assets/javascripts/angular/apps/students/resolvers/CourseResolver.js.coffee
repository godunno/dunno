DunnoAppStudent = angular.module('DunnoAppStudent')

resolver = ($route, ModelResolver, Course) ->
  ModelResolver.resolve Course.get(access_code: $route.current.params.id)

resolver.$inject = ['$route', 'ModelResolver', 'Course']
DunnoAppStudent.constant 'CourseResolver', course: resolver
