attachmentUploader = ->
  attachmentUploaderCtrl = (
    S3Upload,
    Attachment,
    Utils,
    NullPromise
  ) ->
    vm = @
    vm.filePromises ?= []
    vm.attachmentIds ?= []

    attachmentCreated = (attachment) ->
      vm.attachmentIds.push(attachment.id)
      attachment

    createAttachment = (response) ->
      data = response.config.data
      attributes =
        file_url: data.key
        file_size: data.file.size
        original_filename: data.file.name

      new Attachment(attributes).create().then(attachmentCreated)

    # Declaring variable to copy abort function.
    abort = null

    promiseFor = (file) ->
      promise = if file.size <= vm.course.file_size_limit
                  S3Upload.upload(file, vm.course)
                else
                  new NullPromise()

      # Saving abort function due to lack of
      # chaining in ng-file-upload promises.
      abort = promise.abort

      promise = promise.then(createAttachment)
      promise

    filePromiseFor = (file) ->
      promise = promiseFor(file)
      promise.file = file

      # Copying abort function back to promise
      promise.abort = abort

      promise

    vm.upload = (files) ->
      files = [] unless files?
      filePromises = files.map filePromiseFor
      vm.filePromises = vm.filePromises.concat filePromises

    vm.uploadAborted = (filePromise) ->
      Utils.remove(vm.filePromises, filePromise)

    vm.attachmentDeleted = (attachment, filePromise) ->
      Utils.remove(vm.attachmentIds, attachment.id)
      Utils.remove(vm.filePromises, filePromise)

    vm

  attachmentUploaderCtrl.$inject = [
    'S3Upload',
    'Attachment',
    'Utils',
    'NullPromise'
  ]

  restrict: 'E'
  scope:
    attachmentIds: '='
    filePromises: '='
    course: '='
  controller: attachmentUploaderCtrl
  controllerAs: 'vm'
  bindToController: true
  templateUrl: 'courses/events/attachment-uploader.directive'

angular
  .module('app.courses')
  .directive('attachmentUploader', attachmentUploader)
