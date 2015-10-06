attachmentUploader = ->
  attachmentUploaderCtrl = (
    S3Upload,
    Utils,
    NullPromise,
    UPLOAD_LIMIT
  ) ->
    vm = @
    vm.filePromises ?= []
    vm.attachmentIds ?= []

    promiseFor = (file) ->
      if file.size <= UPLOAD_LIMIT
        S3Upload.upload(file)
      else
        new NullPromise()

    filePromiseFor = (file) ->
      promise = promiseFor(file)
      promise.file = file
      promise

    vm.upload = (files) ->
      files = [] unless files?
      promises = files.map filePromiseFor
      vm.filePromises = vm.filePromises.concat promises

    vm.uploadAborted = (filePromise) ->
      Utils.remove(vm.filePromises, filePromise)

    vm.attachmentCreated = (attachment) ->
      vm.attachmentIds.push(attachment.id)

    vm.attachmentDeleted = (attachment, filePromise) ->
      vm.uploadAborted(filePromise)
      Utils.remove(vm.attachmentIds, attachment.id)

    vm

  attachmentUploaderCtrl.$inject = [
    'S3Upload',
    'Utils',
    'NullPromise',
    'UPLOAD_LIMIT'
  ]

  restrict: 'E'
  scope:
    attachmentIds: '='
    filePromises: '='
  controller: attachmentUploaderCtrl
  controllerAs: 'vm'
  bindToController: true
  templateUrl: 'courses/events/attachment-uploader.directive'

angular
  .module('app.courses')
  .directive('attachmentUploader', attachmentUploader)
