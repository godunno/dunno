setupProfileRoutes = (
  $stateProvider) ->
  $stateProvider
    .state 'app.profile',
      url: '/profile/edit'
      controller: 'ProfileCtrl as vm'
      templateUrl: 'profile/profile'
      resolve:
        $title: ['$translate', ($translate) -> $translate('profile.title.edit')]

    .state 'app.profile.change_password',
      url: '/profile/password/edit'
      controller: 'PasswordCtrl'
      templateUrl: 'profile/password'

setupProfileRoutes.$inject = [
  '$stateProvider']

angular
  .module('app.profile')
  .config(setupProfileRoutes)
