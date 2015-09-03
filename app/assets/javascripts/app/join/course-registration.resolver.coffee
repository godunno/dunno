CourseRegistrationResolver = ($stateParams, PageLoading, Course) ->
  PageLoading.resolve Course.search($stateParams.id)

CourseRegistrationResolver.$inject = ['$stateParams', 'PageLoading', 'Course']

angular
  .module('app.join')
  .constant('CourseRegistrationResolver', CourseRegistrationResolver)
