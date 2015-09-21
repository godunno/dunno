CourseMembersCtrl = (course, ModalFactory) ->
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

  @openInviteMembers = ->
    new ModalFactory
      templateUrl: 'courses/invite/invite-members'
      controller: 'InviteMembersController'
      controllerAs: 'vm'
      class: 'small invite__members'
      resolve:
        course: -> course
    .activate()

  @

CourseMembersCtrl.$inject = ['course', 'ModalFactory']

angular
  .module('app.courses')
  .controller('CourseMembersCtrl', CourseMembersCtrl)
