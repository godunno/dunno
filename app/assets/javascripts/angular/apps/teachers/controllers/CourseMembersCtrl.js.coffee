  CourseMembersCtrl = ($scope, course) ->
    $scope.order = (members) ->
      if role(members) == "teacher"
        0
      else
        1

    role = (members) ->
      members[0].role

    $scope.roleName = (members) ->
      translateRole(role(members))

    translateRole = (role) ->
      rolesInPortuguese =
        teacher: 'Professor'
        student: 'Estudante'
      rolesInPortuguese[role]

  CourseMembersCtrl.$inject = ['$scope', 'course']
  angular.module('DunnoApp')
  .controller('CourseMembersCtrl', CourseMembersCtrl)
