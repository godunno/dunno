describe "CourseFoldersCtrl", ->
  beforeEach ->
    module 'app.courses', ($urlRouterProvider, $provide) ->
      $urlRouterProvider.deferIntercept()
      return

  ctrl = null

  course =
    uuid: "0446e5fc-c8c6-40b5-ba8d-b283ddf86549"

  $scope = null

  folder =
    id: 1
    name: "Apostilas"
    course_id: "0446e5fc-c8c6-40b5-ba8d-b283ddf86549"

  folders = [folder]

  mockClass = (Subject) ->
      Surrogate = ->
          Surrogate.prototype.constructor.apply(@, arguments)
      Surrogate.prototype = Object.create(Subject.prototype)
      Surrogate.prototype.constructor = Subject
      Surrogate

  Folder = null

  beforeEach ->
    inject ($controller, $rootScope, _Folder_) ->
      Folder = mockClass(_Folder_)
      $scope = $rootScope.$new()
      $scope.course = course
      ctrl = $controller 'CourseFoldersCtrl',
        $scope: $scope
        folders: folders
        Folder: Folder

  it "assigns folders", ->
    expect(ctrl.folders).toBe(folders)

  it "assigns new folder", ->
    expect(ctrl.newFolder).toEqual(course_id: course.uuid)

  describe "creating new folder", ->
    deferred = null
    newFolder = null

    beforeEach inject ($q) ->
      ctrl.newFolder = newFolder =
        name: "Listas de Exercícios"
        course_id: course.uuid
      deferred = $q.defer()
      window.deferred = deferred

      spyOn(Folder.prototype, 'constructor')
      spyOn(Folder.prototype, 'create').and.returnValue(deferred.promise)

    it "creates a new folder for that course", ->
      ctrl.addFolder()
      expect(Folder.prototype.constructor).toHaveBeenCalledWith(newFolder)
      expect(Folder.prototype.create).toHaveBeenCalled()

    it "adds the new folder to the list of folders", ->
      ctrl.addFolder()
      response =
        id: 2
        name: "Listas de Exercícios"
        course_id: course.uuid
      deferred.resolve(response)
      $scope.$apply()
      expect(ctrl.folders).toEqual([folder, response])

    it "resets the new folder after saving it", ->
      ctrl.addFolder()
      expect(ctrl.newFolder).toEqual(course_id: course.uuid)
