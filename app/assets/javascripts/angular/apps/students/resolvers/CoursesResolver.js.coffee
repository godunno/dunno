DunnoAppStudent = angular.module('DunnoAppStudent')

resolver = (ModelResolver, Course) ->
  ModelResolver.resolve Course.query()

resolver.$inject = ['ModelResolver', 'Course']
DunnoAppStudent.constant 'CoursesResolver', courses: resolver
