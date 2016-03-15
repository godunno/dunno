ChangeMediaFolderCtrl = (media, folders, callback, modalInstance) ->
  vm = @

  vm.media = media
  vm.folders = folders

  vm.updateMedia = ->
    vm.submitting = vm.media.update().then ->
      modalInstance.destroy()
      callback(vm.media)

  @

ChangeMediaFolderCtrl.$inject = ['media', 'folders', 'callback', 'modalInstance']

angular
  .module('app.courses')
  .controller('ChangeMediaFolderCtrl', ChangeMediaFolderCtrl)
