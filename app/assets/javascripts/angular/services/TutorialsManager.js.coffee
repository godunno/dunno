DunnoApp = angular.module('DunnoApp')

TutorialsManager = ($http, $analytics, $location, SessionManager)->
  user = SessionManager.currentUser()

  tutorialKey = (tutorialId) ->
    "user_#{user.id}_tutorial_#{tutorialId}"

  tutorialEnabled = (tutorialId)->
    # TODO: Reenable when we update the tutorial.
    return false
    return false if $location.search().first_access
    return false if user.completed_tutorial
    return true unless localStorage.getItem(tutorialKey(tutorialId))
    false

  TUTORIALS = [1, 2, 3]
  tutorialClosed = (tutorialId)->
    localStorage.setItem(tutorialKey(tutorialId), true)
    finished = TUTORIALS
      .map((id)-> localStorage.getItem(tutorialKey(id)))
      .reduce((previous, current)-> previous && current)
    if finished
      $http.patch("/api/v1/users", user: {completed_tutorial: true}).then (response)->
        SessionManager.setCurrentUser(response.data)
        $analytics.eventTrack('Finished tutorial')

    # TODO: Fix bug with updating during digest
    if Intercom?
      Intercom('shutdown')
      Intercom('boot', intercomSettings)

  {
    tutorialEnabled: tutorialEnabled
    tutorialClosed: tutorialClosed
  }

TutorialsManager.$inject = ['$http', '$analytics', '$location', 'SessionManager']
DunnoApp.factory "TutorialsManager", TutorialsManager
