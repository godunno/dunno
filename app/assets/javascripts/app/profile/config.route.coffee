setupProfileRoutes = (
  $stateProvider) ->
  $stateProvider
    .state 'profile',
      url: '/profile/edit'
      controller: 'ProfileCtrl'
      templateUrl: 'profile/profile'

    .state 'profile.change_password',
      url: '/profile/password/edit'
      controller: 'PasswordCtrl'
      templateUrl: 'profile/password'

setupProfileRoutes.$inject = [
  '$stateProvider']

angular
  .module('app.profile')
  .config(setupProfileRoutes)
