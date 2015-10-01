loginWithFacebook = ->
  templateUrl: 'core/components/login-with-facebook.directive'
  restrict: 'E'

angular
  .module('app.core')
  .directive('loginWithFacebook', loginWithFacebook)
