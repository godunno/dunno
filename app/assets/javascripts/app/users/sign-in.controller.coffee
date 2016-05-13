SignInCtrl = ($scope, $window, SessionManager, regularParams) ->
  $scope.user = {}

  $scope.redirectTo = regularParams.get('redirectTo')

  $scope.sign_in = (user) ->
    $scope.authentication_failed = false

    $scope.submitting = SessionManager.signIn(user).then((data) ->
      $window.location.href = $scope.redirectTo || data.root_path
    ).catch(-> $scope.authentication_failed = true)

SignInCtrl.$inject = ['$scope', '$window', 'SessionManager', 'regularParams']

angular
  .module('app.users')
  .controller('SignInCtrl', SignInCtrl)
