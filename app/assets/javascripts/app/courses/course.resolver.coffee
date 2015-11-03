CourseResolver = ($stateParams, PageLoading, Course, FoundationApi) ->
  failure = (response) ->
    if response.status == 404
      FoundationApi.publish 'main-notifications',
        content: 'Você não está cadastrado nessa disciplina.'
        color: 'alert'
    if response.status == 403
      FoundationApi.publish 'main-notifications',
        content: 'Você foi bloqueado nessa disciplina.'
        color: 'alert'
  courseParams = { uuid: $stateParams.courseId }
  params = { month: $stateParams.month }

  PageLoading.resolve Course.get(courseParams, params).catch(failure)

CourseResolver.$inject = ['$stateParams', 'PageLoading', 'Course', 'FoundationApi']

angular
  .module('app.core')
  .constant('CourseResolver', CourseResolver)
