CoursesResolver = (PageLoading, Course) ->
  PageLoading.resolve Course.query()

CoursesResolver.$inject = ['PageLoading', 'Course']

angular
  .module('app.courses')
  .constant('CoursesResolver', CoursesResolver)
