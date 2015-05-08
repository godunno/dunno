DunnoApp = angular.module('DunnoApp')
DunnoAppStudent = angular.module('DunnoAppStudent')

PageLoading = ($rootScope) ->
  @resolve = (promise) ->
    $rootScope.$broadcast 'wholePageLoading', promise
    promise
  @

PageLoading.$inject = ['$rootScope']
DunnoApp.service 'PageLoading', PageLoading
DunnoAppStudent.service 'PageLoading', PageLoading
