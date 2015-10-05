attachmentUploader = ->
  attachmentUploaderCtrl = (
    S3Upload,
    Utils,
    NullPromise,
    UPLOAD_LIMIT
  ) ->
    vm = @
    vm.files = []

    setPromiseFor = (file) ->
      file.promise = if file.size <= UPLOAD_LIMIT
                       S3Upload.upload(file)
                     else
                       NullPromise

    vm.upload = (files) ->
      files = [] unless files?
      files.forEach setPromiseFor
      vm.files = vm.files.concat files

    vm.removeFile = (file) ->
      Utils.remove(vm.files, file)

    vm.attachmentCreated = (attachment) ->
      vm.onCreate()?(attachment)

    vm.attachmentDeleted = (attachment, file) ->
      vm.removeFile(file)
      vm.onDelete()?(attachment)

    vm

  attachmentUploaderCtrl.$inject = [
    'S3Upload',
    'Utils',
    'NullPromise',
    'UPLOAD_LIMIT'
  ]

  restrict: 'E'
  controller: attachmentUploaderCtrl
  scope:
    onCreate: '&'
    onDelete: '&'
  controllerAs: 'vm'
  bindToController: true
  templateUrl: 'courses/events/attachment-uploader.directive'
  link: (scope, element, attrs) ->
    sendFileButton = element.find('.send-file')
    fileInput = element.find('input[type=file]')
    sendFileButton.click(-> fileInput.click())

angular
  .module('app.courses')
  .directive('attachmentUploader', attachmentUploader)
