describe "attachment-uploader directive", ->
  beforeEach module('app.templates')
  beforeEach ->
    module 'app.core', ($provide) ->
      $provide.value('S3Upload', mockS3Upload)
      return

    module 'app.courses', ($urlRouterProvider) ->
      $urlRouterProvider.deferIntercept()
      return

  $q = null
  $timeout = null
  $httpBackend = null
  NullPromise = null

  scope = null
  element = null
  ctrl = null
  deferred = null

  mockS3Upload =
    upload: -> new NullPromise()

  [file1, file2] = [
    { name: 'file1.txt', size: 123 },
    { name: 'file2.txt', size: 123 }
  ]

  attachment =
    id: 1
    url: 'http://www.example.com/file.txt'
    original_filename: file1.name
    file_size: file1.size

  course =
    file_size_limit: 1024 * 1024 * 10

  beforeEach ->
    inject ($compile, $rootScope, _$httpBackend_, _$q_, _$timeout_, _NullPromise_) ->
      $httpBackend = _$httpBackend_
      $q = _$q_
      $timeout = _$timeout_
      NullPromise = _NullPromise_

      scope = $rootScope.$new()
      scope.attachmentIds = undefined
      scope.filePromises = undefined
      scope.course = course
      template = """
        <attachment-uploader
         attachment-ids="attachmentIds"
         file-promises="filePromises"
         course="course">
      """
      element = $compile(template)(scope)
      element.appendTo(document.body)
      scope.$digest()
      ctrl = element.controller('attachmentUploader')

      $httpBackend.whenPOST('/api/v1/attachments').respond attachment

  afterEach ->
    element.remove()

  it "calls S3Upload service after selecting files", ->
    spyOn(mockS3Upload, 'upload').and.returnValue(new NullPromise())
    ctrl.upload([file1, file2])

    calls = mockS3Upload.upload.calls.all()
    expect(calls[0].args).toEqual([file1, course])
    expect(calls[1].args).toEqual([file2, course])

  xit "has a button with ngfSelect which calls upload", ->
    # Stupid ng-file-upload puts the file input at the
    # bottom of the body and doesn't remove it when the
    # element is removed from the DOM, making it hard to test.
    spyOn(ctrl, 'upload')
    fileSelect = element.find('[ngf-select]')
    fileSelect.trigger('change')
    $timeout.flush()
    expect(ctrl.upload).toHaveBeenCalled()

  describe "after selecting files", ->
    deferred1 = null
    promise1 = null
    deferred2 = null
    promise2 = null

    beforeEach ->
      deferred1 = $q.defer()
      promise1 = deferred1.promise.then ->
        config:
          data:
            key: 'http://www.example.com/file.txt'
            file: file1

      promise1.file = file1

      deferred2 = $q.defer()
      promise2 = deferred2.promise.then -> response
      promise2.file = file2

      spyOn(mockS3Upload, 'upload').and.callFake (file) ->
        return promise1 if file == file1
        return promise2 if file == file2

      ctrl.upload([file1, file2])
      scope.$apply()

    it "assigns files after selecting files", ->
      expect(ctrl.filePromises.length).toBe(2)

    it "allows appending more files", ->
      ctrl.upload([name: 'file3.txt'])
      scope.$apply()

      expect(ctrl.filePromises.length).toBe(3)

    it "shows each file on the template", ->
      expect(element.find('attachment-item').length).toBe(2)

    it "removes file from list when it's aborted", ->
      ctrl.uploadAborted(ctrl.filePromises[0])
      expect(ctrl.filePromises.length).toBe(1)

    describe "after the Attachment is created", ->
      attachment = { id: 1 }

      beforeEach ->
        deferred1.resolve()
        $httpBackend.flush()
        scope.$apply()

      it "adds an Attachment's id to the list when it's created", ->
        expect(scope.attachmentIds).toEqual([attachment.id])

      it "removes an Attachment's id from the list when it's deleted", ->
        ctrl.attachmentDeleted(attachment, ctrl.filePromises[0])
        expect(scope.attachmentIds).toEqual([])

      it "removes an Attachment's file from the list when it's deleted", ->
        ctrl.attachmentDeleted(attachment, ctrl.filePromises[0])
        expect(ctrl.filePromises.length).toBe(1)
