attachment = ->
  attachmentController = (
    $scope,
    $element,
    Attachment,
    UPLOAD_LIMIT
  ) ->
    vm = @
    ngModelCtrl = $element.controller('ngModel')
    promise = vm.file.promise
    state = 'uploading'

    if vm.file.size > UPLOAD_LIMIT
      ngModelCtrl.$setValidity('file_too_big', false)
      state = 'error.file_too_big'

    promise.then (response) ->
      attributes =
        file_url: response.config.data.key
        file_size: vm.file.size
        original_filename: vm.file.name

      vm.attachment = new Attachment(attributes)

      vm.attachment.create().then ->
        state = 'completed'
        vm.onCreate()?(vm.attachment)

    vm.abort = ->
      promise.abort()
      vm.onAbort()?(vm.file)

    vm.delete = ->
      vm.attachment.delete().then ->
        vm.onDelete()?(vm.attachment, vm.file)

    vm.isUploading = -> state == 'uploading'
    vm.isCompleted = -> state == 'completed'
    vm.hasError = (error) ->
      error ?= ''
      !!RegExp("error\\.#{error}").exec(state)

    vm

  attachmentController.$inject = [
    '$scope',
    '$element',
    'Attachment',
    'UPLOAD_LIMIT'
  ]

  restrict: 'E'
  require: 'ngModel'
  scope:
    file: '=ngModel'
    onAbort: '&'
    onDelete: '&'
    onCreate: '&'
  controller: attachmentController
  controllerAs: 'vm'
  bindToController: true
  templateUrl: 'courses/events/attachment.directive'

angular
  .module('app.courses')
  .directive('attachment', attachment)
