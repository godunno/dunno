#describe "attachment directive", ->
#  beforeEach module('app.templates')
#  beforeEach ->
#    module 'app.courses', ($urlRouterProvider, $provide) ->
#      $urlRouterProvider.deferIntercept()
#      $provide.value('Attachment', Attachment)
#      return
#
#  $q = null
#
#  scope = null
#  element = null
#  ctrl = null
#
#  file = { name: 'file.txt', size: 1024 }
#  file_url = 'path/to/file.txt'
#
#  deferred = null
#  promise = null
#  attachmentDeferred = null
#
#  Attachment = (args...) -> @initialize(args...)
#  Attachment.prototype.initialize = (->)
#  Attachment.prototype.create = -> attachmentDeferred.promise
#  Attachment.prototype.delete = -> attachmentDeferred.promise
#
#  abortCallback = jasmine.createSpy('abortCallback')
#  deleteCallback = jasmine.createSpy('deleteCallback')
#  createCallback = jasmine.createSpy('createCallback')
#
#  response =
#    config:
#      data:
#        key: file_url
#
#  beforeEach ->
#    inject ($compile, $rootScope, _$q_) ->
#      $q = _$q_
#      deferred = $q.defer()
#      promise = deferred.promise
#      promise.abort = -> promise
#      attachmentDeferred = $q.defer()
#
#      scope = $rootScope.$new()
#      scope.file = file
#      scope.promise = promise
#      scope.abortCallback = abortCallback
#      scope.deleteCallback = deleteCallback
#      scope.createCallback = createCallback
#
#      template = """
#        <attachment file="file" promise="promise" on-delete="deleteCallback" on-abort="abortCallback" on-create="createCallback">
#      """
#
#      element = $compile(template)(scope)
#      element.appendTo(document.body)
#      scope.$digest()
#      ctrl = element.controller('attachment')
#
#  afterEach ->
#    element.remove()
#
#  it "starts as uploading", ->
#    expect(ctrl.state).toEqual('uploading')
#
#  it "doesn't have a button to delete attachment", ->
#    expect(element.find('.delete').length).toBe(0)
#
#  it "shows a button to abort the upload", ->
#    spyOn(promise, 'abort').and.callThrough()
#    element.find('.abort').click()
#    scope.$apply()
#    expect(promise.abort).toHaveBeenCalled()
#
#  it "calls callback after clicking abort button", ->
#    element.find('.abort').click()
#    scope.$apply()
#    expect(abortCallback).toHaveBeenCalledWith(file)
#
#  it "shows the file's name", ->
#    expect(element.find('.file-name').text().trim()).toEqual(file.name)
#
#  it "shows the file's size", ->
#    expect(element.find('.file-size').text().trim()).toEqual('1.0 kB')
#
#  it "creates an Attachment after upload", ->
#    spyOn(Attachment.prototype, 'initialize')
#    spyOn(Attachment.prototype, 'create').and.returnValue attachmentDeferred.promise
#    deferred.resolve(response)
#    attachmentDeferred.resolve()
#    scope.$apply()
#    expect(Attachment.prototype.initialize).toHaveBeenCalledWith
#      file_url: file_url
#      file_size: file.size
#      original_filename: file.name
#    expect(Attachment.prototype.create).toHaveBeenCalled()
#
#  it "changes to completed", ->
#    spyOn(Attachment.prototype, 'create').and.returnValue attachmentDeferred.promise
#    deferred.resolve(response)
#    scope.$apply()
#    expect(ctrl.state).toEqual('uploading')
#    attachmentDeferred.resolve()
#    scope.$apply()
#    expect(ctrl.state).toEqual('completed')
#
#  it "calls callback after creating attachment", ->
#    deferred.resolve(response)
#    scope.$apply()
#    expect(createCallback).not.toHaveBeenCalled()
#
#    attachmentDeferred.resolve()
#    scope.$apply()
#    expect(createCallback).toHaveBeenCalledWith(ctrl.attachment)
#
#  describe "after upload", ->
#    beforeEach ->
#      deferred.resolve(response)
#      attachmentDeferred.resolve()
#      scope.$apply()
#
#    it "assigns an Attachment", ->
#      expect(Attachment.prototype.isPrototypeOf(ctrl.attachment)).toBe(true)
#
#    it "doesn't have a button to abort upload", ->
#      expect(element.find('.abort').length).toBe(0)
#
#    it "shows a button to delete attachment", ->
#      spyOn(ctrl.attachment, 'delete').and.returnValue
#        then: (callback) -> callback()
#      element.find('.delete').click()
#      scope.$apply()
#      expect(ctrl.attachment.delete).toHaveBeenCalled()
#
#    it "calls callback after clicking delete button", ->
#      element.find('.delete').click()
#      scope.$apply()
#      expect(deleteCallback).toHaveBeenCalledWith(ctrl.attachment)
