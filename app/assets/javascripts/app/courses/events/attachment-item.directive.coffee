attachmentItem = ->
  attachmentItemController = (
    $scope,
    $element,
    Attachment,
    UPLOAD_LIMIT
  ) ->
    vm = @
    ngModelCtrl = $element.controller('ngModel')
    state = 'uploading'

    if vm.file.size > UPLOAD_LIMIT
      ngModelCtrl.$setValidity('file_too_big', false)
      state = 'error.file_too_big'

    vm.promise.then (response) ->
      attributes =
        file_url: response.config.data.key
        file_size: vm.file.size
        original_filename: vm.file.name

      vm.attachment = new Attachment(attributes)

      vm.attachment.create().then ->
        state = 'completed'
        vm.onCreate()(vm.attachment)

    vm.abort = ->
      vm.promise.abort()
      vm.onAbort()(vm.promise)

    vm.delete = ->
      vm.attachment.delete().then ->
        vm.onDelete()(vm.attachment, vm.promise)

    vm.isUploading = -> state == 'uploading'
    vm.isCompleted = -> state == 'completed'
    vm.hasError = (error) ->
      error ?= ''
      !!RegExp("error\\.#{error}").exec(state)

    vm

  attachmentItemController.$inject = [
    '$scope',
    '$element',
    'Attachment',
    'UPLOAD_LIMIT'
  ]

  restrict: 'E'
  require: 'ngModel'
  scope:
    file: '=ngModel'
    promise: '='
    onAbort: '&'
    onDelete: '&'
    onCreate: '&'
  controller: attachmentItemController
  controllerAs: 'vm'
  bindToController: true
  templateUrl: 'courses/events/attachment-item.directive'

angular
  .module('app.courses')
  .directive('attachmentItem', attachmentItem)
