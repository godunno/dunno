InviteMembersController = (ModalFactory, course) ->
  @course = course
  @openInviteMembersFullscreen = ->
    new ModalFactory
      templateUrl: 'courses/invite/invite-fullscreen'
      controller: 'InviteMembersFullscreenController'
      controllerAs: 'vm'
      class: 'full invite__members__fullscreen'
      resolve:
        course: -> course
    .activate()

  @

InviteMembersController.$inject = ['ModalFactory', 'course']

angular
  .module('app.courses')
  .controller('InviteMembersController', InviteMembersController)