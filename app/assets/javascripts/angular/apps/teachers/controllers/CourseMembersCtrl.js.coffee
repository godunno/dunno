  CourseMembersCtrl = (course) ->
    role = (members) ->
      members[0].role

    @order = (members) ->
      if role(members) == "teacher"
        0
      else
        1


    @roleName = (members) ->
      @translateRole(role(members))

    @translateRole = (role) ->
      rolesInPortuguese =
        teacher: 'Professor'
        student: 'Estudante'
      rolesInPortuguese[role]

    @

  CourseMembersCtrl.$inject = ['course']

  angular
    .module('DunnoApp')
    .controller('CourseMembersCtrl', CourseMembersCtrl)
