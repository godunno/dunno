PageLoading = ($rootScope) ->
  @resolve = (promise) ->
    $rootScope.$broadcast 'wholePageLoading', promise
    promise
  @

PageLoading.$inject = ['$rootScope']

angular
  .module('app.core')
  .service('PageLoading', PageLoading)
