CourseMembersCtrl = (course, ModalFactory, PageLoading) ->
  role = (members) ->
    members[0].role

  @order = (members) ->
    if role(members) == "teacher"
      0
    else if role(members) == "student"
      1
    else
      2

  @roleName = (members) ->
    @translateRole(role(members))

  @translateRole = (role) ->
    rolesInPortuguese =
      teacher: 'Professor'
      student: 'Estudante'
      blocked: 'Bloqueado'
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

  @block = (member) ->
    message = """
      Atenção:
      Ao bloquear o acesso, esse(a) estudante não irá mais acessar a disciplina e seu conteúdo.
      Tem certeza que deseja prosseguir?s
    """
    return unless confirm(message)
    PageLoading.resolve(course.block(member.id)).then ->
      member.role = 'blocked'

  @unblock = (member) ->
    PageLoading.resolve(course.unblock(member.id)).then ->
      member.role = 'student'

  @

CourseMembersCtrl.$inject = ['course', 'ModalFactory', 'PageLoading']

angular
  .module('app.courses')
  .controller('CourseMembersCtrl', CourseMembersCtrl)
