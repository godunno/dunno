DunnoApp = angular.module('DunnoApp')

resolver = (ModelResolver, Course) ->
  ModelResolver.resolve Course.query()

resolver.$inject = ['ModelResolver', 'Course']
DunnoApp.constant 'CoursesResolver', courses: resolver
