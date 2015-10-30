setAppRoutes = ($stateProvider) ->
  $stateProvider
    .state 'app',
      url: ''
      abstract: true
      template: '<ui-view/>'
      sticky: true

setAppRoutes.$inject = ['$stateProvider']

angular
  .module('app.core')
  .config(setAppRoutes)
