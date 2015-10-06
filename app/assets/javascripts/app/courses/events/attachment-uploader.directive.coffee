attachmentUploader = ->
  attachmentUploaderCtrl = (
    S3Upload,
    Utils,
    NullPromise,
    UPLOAD_LIMIT
  ) ->
    vm = @
    vm.files = []
    vm.attachmentIds ?= []

    setPromiseFor = (file) ->
      file.promise = if file.size <= UPLOAD_LIMIT
                       S3Upload.upload(file)
                     else
                       NullPromise

    vm.upload = (files) ->
      files = [] unless files?
      files.forEach setPromiseFor
      vm.files = vm.files.concat files

    vm.uploadAborted = (file) ->
      Utils.remove(vm.files, file)

    vm.attachmentCreated = (attachment) ->
      vm.attachmentIds.push(attachment.id)

    vm.attachmentDeleted = (attachment, file) ->
      Utils.remove(vm.files, file)
      Utils.remove(vm.attachmentIds, attachment.id)

    vm

  attachmentUploaderCtrl.$inject = [
    'S3Upload',
    'Utils',
    'NullPromise',
    'UPLOAD_LIMIT'
  ]

  restrict: 'E'
  require: 'ngModel'
  scope:
    attachmentIds: '=ngModel'
  controller: attachmentUploaderCtrl
  controllerAs: 'vm'
  bindToController: true
  templateUrl: 'courses/events/attachment-uploader.directive'

angular
  .module('app.courses')
  .directive('attachmentUploader', attachmentUploader)
