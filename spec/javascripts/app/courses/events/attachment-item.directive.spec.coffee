describe "attachment-item directive", ->
  beforeEach module('app.templates')
  beforeEach ->
    module 'app.courses', ($urlRouterProvider, $provide) ->
      $urlRouterProvider.deferIntercept()
      return

  $q = null
  $compile = null

  scope = null
  element = null
  ctrl = null

  deferred = null
  promise = null

  file = { name: 'file.txt', size: 1024 }
  file_url = 'path/to/file.txt'
  Attachment =
    delete: (->)

  abortCallback = jasmine.createSpy('abortCallback')
  deleteCallback = jasmine.createSpy('deleteCallback')

  response =
    config:
      data:
        key: file_url

  template = """
    <attachment-item
     ng-model="file"
     promise="promise"
     on-delete="deleteCallback"
     on-abort="abortCallback">
  """

  beforeEach ->
    inject (_$compile_, $rootScope, _$q_) ->
      $compile = _$compile_
      $q = _$q_

      deferred = $q.defer()

      promise = deferred.promise.then -> Attachment
      promise.abort = -> promise

      scope = $rootScope.$new()
      scope.file = file
      scope.promise = promise
      scope.abortCallback = abortCallback
      scope.deleteCallback = deleteCallback

      element = $compile(template)(scope)
      element.appendTo(document.body)
      scope.$digest()
      ctrl = element.controller('attachmentItem')

  afterEach ->
    element.remove()

  it "starts as uploading", ->
    expect(ctrl.isUploading()).toBe(true)
    expect(ctrl.isCompleted()).toBe(false)

  it "doesn't have a button to delete attachment", ->
    expect(element.find('.attachment__delete').length).toBe(0)

  it "shows a button to abort the upload", ->
    spyOn(promise, 'abort').and.callThrough()
    element.find('.attachment__delete').click()
    scope.$apply()
    expect(promise.abort).toHaveBeenCalled()

  it "calls callback after clicking abort button", ->
    element.find('.attachment__delete').click()
    scope.$apply()
    expect(abortCallback).toHaveBeenCalledWith(promise)

  it "shows the file's name", ->
    expect(element.find('.attachment__name').text().trim()).toEqual(file.name)

  it "shows the file's size", ->
    expect(element.find('.attachment__size').text().trim()).toEqual('1.0 kB')

  it "changes to completed", ->
    deferred.resolve(response)
    scope.$apply()
    expect(ctrl.isCompleted()).toBe(true)
    expect(ctrl.isUploading()).toBe(false)

  it "shows error for file too big", ->
    inject (UPLOAD_LIMIT) ->
      scope.file = { name: 'file.txt', size: UPLOAD_LIMIT + 1, promise: promise }
      otherElement = $compile(template)(scope)
      scope.$digest()
      ctrl = otherElement.controller('attachmentItem')
      expect(ctrl.hasError('file_too_big')).toBe(true)
      expect(otherElement.find('.message__error').length).toBe(1)
      otherElement.remove()

  describe "after upload", ->
    beforeEach ->
      deferred.resolve(response)
      scope.$apply()

    it "doesn't have a button to abort upload", ->
      expect(element.find('.attachment__delete').length).toBe(0)

    it "shows a button to delete attachment", ->
      spyOn(ctrl.attachment, 'delete').and.returnValue
        then: (callback) -> callback()
      element.find('.attachment__delete').click()
      scope.$apply()
      expect(ctrl.attachment.delete).toHaveBeenCalled()
      expect(deleteCallback).toHaveBeenCalledWith(ctrl.attachment, promise)
