InviteMembersController = (
  $window,
  $state,
  ModalFactory,
  course
) ->
  @course = course
  @registerLink =
    $window.location.origin +
    $window.location.pathname +
    $state.href('app.courses.confirm_registration', id: course.access_code)

  @openInviteMembersFullscreen = ->
    new ModalFactory
      templateUrl: 'courses/invite/invite-fullscreen'
      controller: 'InviteMembersFullscreenController'
      controllerAs: 'vm'
      class: 'large invite__members__fullscreen'
      resolve:
        course: -> course
    .activate()

  @

InviteMembersController.$inject = [
  '$window',
  '$state',
  'ModalFactory',
  'course'
]

angular
  .module('app.courses')
  .controller('InviteMembersController', InviteMembersController)
