DunnoApp = angular.module('DunnoApp')

ModelResolver = ($rootScope) ->
  @resolve = (promise) ->
    $rootScope.$broadcast 'wholePageLoading', promise
    promise
  @

ModelResolver.$inject = ['$rootScope']
DunnoApp.service 'ModelResolver', ModelResolver
