SignInCtrl = ($scope, $window, SessionManager) ->
  $scope.user = {}

  getParameterByName = (name, url) ->
    name = name.replace(/[\[\]]/g, "\\$&")
    regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)")
    results = regex.exec(url)
    return null if !results
    return '' if !results[2]
    return $window.decodeURIComponent(results[2].replace(/\+/g, " "))

  $scope.redirectTo = getParameterByName('redirectTo', $window.location.href)

  $scope.sign_in = (user) ->
    $scope.authentication_failed = false

    $scope.submitting = SessionManager.signIn(user).then((data) ->
      $window.location.href = $scope.redirectTo || data.root_path
    ).catch(-> $scope.authentication_failed = true)

SignInCtrl.$inject = ['$scope', '$window', 'SessionManager']

angular
  .module('app.users')
  .controller('SignInCtrl', SignInCtrl)
