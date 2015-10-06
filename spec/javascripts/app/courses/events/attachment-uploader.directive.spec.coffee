describe "attachment-uploader directive", ->
  beforeEach module('app.templates')
  beforeEach ->
    module 'app.core', ($provide) ->
      $provide.value('S3Upload', mockS3Upload)
      return

    module 'app.courses', ($urlRouterProvider) ->
      $urlRouterProvider.deferIntercept()
      return

  $timeout = null
  scope = null
  element = null
  ctrl = null
  NullPromise = null

  mockS3Upload =
    upload: -> NullPromise

  [file1, file2] = [
    { name: 'file1.txt', size: 123 },
    { name: 'file2.txt', size: 123 }
  ]

  beforeEach ->
    inject ($compile, $rootScope, _$timeout_, _NullPromise_) ->
      NullPromise = _NullPromise_
      $timeout = _$timeout_
      scope = $rootScope.$new()
      scope.attachmentIds = []
      element = $compile('<attachment-uploader ng-model="attachmentIds">')(scope)
      element.appendTo(document.body)
      scope.$digest()
      ctrl = element.controller('attachmentUploader')

  afterEach ->
    element.remove()

  it "calls S3Upload service after selecting files", ->
    spyOn(mockS3Upload, 'upload')
    ctrl.upload([file1, file2])

    calls = mockS3Upload.upload.calls.all()
    expect(calls[0].args).toEqual([file1])
    expect(calls[1].args).toEqual([file2])

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
    beforeEach ->
      ctrl.upload([file1, file2])
      scope.$apply()

    it "assigns files after selecting files", ->
      expect(ctrl.files).toEqual([file1, file2])

    it "allows appending more files", ->
      ctrl.upload([name: 'file3.txt'])
      scope.$apply()

      expect(element.find('.attachment').length).toBe(3)

    it "shows each file on the template", ->
      expect(element.find('attachment-item').length).toBe(2)

    it "removes file from list when it's aborted", ->
      ctrl.uploadAborted(file1)
      expect(ctrl.files).toEqual([file2])

    describe "after the Attachment is created", ->
      attachment = { id: 1 }

      beforeEach ->
        ctrl.attachmentCreated(attachment)
        scope.$apply()

      it "adds an Attachment's id to the list when it's created", ->
        expect(scope.attachmentIds).toEqual([1])

      it "removes an Attachment's id from the list when it's deleted", ->
        ctrl.attachmentDeleted(attachment, file1)
        expect(scope.attachmentIds).toEqual([])

      it "removes an Attachment's file from the list when it's deleted", ->
        ctrl.attachmentDeleted(attachment, file1)
        expect(ctrl.files).toEqual([file2])
