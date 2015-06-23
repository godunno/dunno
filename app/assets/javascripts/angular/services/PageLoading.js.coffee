DunnoApp = angular.module('DunnoApp')

PageLoading = ($rootScope) ->
  @resolve = (promise) ->
    $rootScope.$broadcast 'wholePageLoading', promise
    promise
  @

PageLoading.$inject = ['$rootScope']
DunnoApp.service 'PageLoading', PageLoading
