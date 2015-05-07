DunnoApp = angular.module('DunnoApp')
DunnoAppStudent = angular.module('DunnoAppStudent')

ModelResolver = ($rootScope) ->
  @resolve = (promise) ->
    $rootScope.$broadcast 'wholePageLoading', promise
    promise
  @

ModelResolver.$inject = ['$rootScope']
DunnoApp.service 'ModelResolver', ModelResolver
DunnoAppStudent.service 'ModelResolver', ModelResolver
