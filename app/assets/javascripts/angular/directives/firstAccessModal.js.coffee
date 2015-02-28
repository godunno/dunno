DunnoApp = angular.module('DunnoApp')

DunnoApp.controller 'firstAccessModalCtrl', ['$scope', '$http', '$window', 'SessionManager', ($scope, $http, $window, SessionManager)->
  $scope.user = SessionManager.currentUser()

  $scope.updatePassword = (user)->
    $http.patch('/users', user: user).then(->
      $scope.element.foundation('reveal', 'close')
      $window.location = $window.location.pathname
    )
]

DunnoApp.directive 'firstAccessModal', ['$location', ($location)->
  restrict: 'A'
  scope: true
  controller: 'firstAccessModalCtrl'
  link: (scope, element, attrs)->
    scope.element = element
    if $location.search().first_access
      element.foundation('reveal', 'open', close_on_background_click: false)
]
