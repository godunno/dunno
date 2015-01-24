DunnoApp = angular.module('DunnoApp')
DunnoAppStudent = angular.module('DunnoAppStudent')

TutorialsManager = ($http, SessionManager)->

  tutorialEnabled = (tutorialId)->
    SessionManager.currentUser().completed_tutorial
    return false if SessionManager.currentUser().completed_tutorial
    return true unless localStorage.getItem("tutorial_#{tutorialId}")
    false

  TUTORIALS = [1, 2, 3]
  tutorialClosed = (tutorialId)->
    localStorage.setItem("tutorial_#{tutorialId}", true)
    finished = TUTORIALS
      .map((id)-> localStorage.getItem("tutorial_#{id}"))
      .reduce((previous, current)-> previous && current)
    if finished
      $http.patch("/api/v1/users", user: {completed_tutorial: true}).then (response)->
        SessionManager.setCurrentUser(response.data)

  {
    tutorialEnabled: tutorialEnabled
    tutorialClosed: tutorialClosed
  }

TutorialsManager.$inject = ['$http', 'SessionManager']
DunnoApp.factory "TutorialsManager", TutorialsManager
DunnoAppStudent.factory "TutorialsManager", TutorialsManager
