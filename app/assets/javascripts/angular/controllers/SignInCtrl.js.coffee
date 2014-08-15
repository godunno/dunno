DunnoApp = angular.module('DunnoApp')

SignInCtrl = ($scope)->
  $scope.user_type = "student"
  $scope.form_action = -> "#{$scope.user_type}s/sign_in"
  $scope.field_name = (field)-> "#{$scope.user_type}[#{field}]"
SignInCtrl.$inject = ['$scope']
DunnoApp.controller 'SignInCtrl', SignInCtrl

