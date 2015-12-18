CourseFolderCtrl = (folder) ->
  vm = @
  vm.folder = folder
  @

CourseFolderCtrl.$inject = ['folder']

angular
  .module('app.courses')
  .controller('CourseFolderCtrl', CourseFolderCtrl)
