loginWithFacebook = ->
  templateUrl: 'core/components/login-with-facebook.directive'
  restrict: 'E'
  scope:
    redirectTo: '=?'

angular
  .module('app.core')
  .directive('loginWithFacebook', loginWithFacebook)
