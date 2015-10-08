attachmentItem = ->
  attachmentItemController = (
    $element,
    UPLOAD_LIMIT
  ) ->
    vm = @
    ngModelCtrl = $element.controller('ngModel')
    state = 'uploading'

    if vm.file.size > UPLOAD_LIMIT
      ngModelCtrl.$setValidity('file_too_big', false)
      state = 'error.file_too_big'

    vm.promise.then (attachment) ->
      vm.attachment = attachment
      state = 'completed'

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
    '$element',
    'UPLOAD_LIMIT'
  ]

  restrict: 'E'
  require: 'ngModel'
  scope:
    file: '=ngModel'
    promise: '='
    onAbort: '&'
    onDelete: '&'
  controller: attachmentItemController
  controllerAs: 'vm'
  bindToController: true
  templateUrl: 'courses/events/attachment-item.directive'

angular
  .module('app.courses')
  .directive('attachmentItem', attachmentItem)
