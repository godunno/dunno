#describe "attachmentUploader directive", ->
#  beforeEach module('app.templates')
#  beforeEach ->
#    module 'app.core', ($provide) ->
#      $provide.value('S3Upload', mockS3Upload)
#      return
#
#    module 'app.courses', ($urlRouterProvider) ->
#      $urlRouterProvider.deferIntercept()
#      return
#
#  $timeout = null
#  scope = null
#  element = null
#  ctrl = null
#
#  Promise = ->
#    @then = (->)
#
#  mockS3Upload =
#    upload: ->
#      new Promise()
#
#  [file1, file2] = [
#    { name: 'file1.txt' },
#    { name: 'file2.txt' }
#  ]
#
#  beforeEach ->
#    inject ($compile, $rootScope, _$timeout_) ->
#      $timeout = _$timeout_
#      scope = $rootScope.$new()
#      element = $compile('<attachment-uploader>')(scope)
#      element.appendTo(document.body)
#      scope.$digest()
#      ctrl = element.controller('attachmentUploader')
#
#  afterEach ->
#    element.remove()
#
#  it "calls Upload service after selecting files", ->
#    spyOn(mockS3Upload, 'upload')
#    ctrl.upload([file1, file2])
#
#    calls = mockS3Upload.upload.calls.all()
#    expect(calls[0].args).toEqual([file1])
#    expect(calls[1].args).toEqual([file2])
#
#  it "shows each file on the template", ->
#    ctrl.upload([file1, file2])
#    scope.$apply()
#    expect(element.find('.attachment').length).toBe(2)
#
#  it "allows appending more files", ->
#    ctrl.upload([file1, file2])
#    scope.$apply()
#
#    ctrl.upload([name: 'file3.txt'])
#    scope.$apply()
#
#    expect(element.find('.attachment').length).toBe(3)
#
#  it "has a button with ngfSelect which calls upload", ->
#    spyOn(ctrl, 'upload')
#    fileSelect = element.find('[ngf-select]')
#    fileSelect.trigger('change')
#    $timeout.flush()
#    expect(ctrl.upload).toHaveBeenCalled()
