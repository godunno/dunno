DunnoApp = angular.module('DunnoApp')

resolver = ($route, ModelResolver, Course) ->
  ModelResolver.resolve Course.get(uuid: $route.current.params.id)

resolver.$inject = ['$route', 'ModelResolver', 'Course']
DunnoApp.constant 'CourseResolver', course: resolver
