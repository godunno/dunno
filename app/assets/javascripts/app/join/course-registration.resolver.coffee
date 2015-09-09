resolver = ($stateParams, PageLoading, Course) ->
  PageLoading.resolve Course.search($stateParams.id)

resolver.$inject = ['$stateParams', 'PageLoading', 'Course']

angular
  .module('app.join')
  .constant 'CourseRegistrationResolver', resolver
