CourseFoldersCtrl = ($scope, folders, Folder) ->
  vm = @

  reset = ->
    vm.newFolder =
      course_id: $scope.course.uuid

  reset()

  vm.folders = folders

  vm.addFolder = () ->
    new Folder(vm.newFolder).create().then((folder) -> vm.folders.push(folder))
    reset()

  @

CourseFoldersCtrl.$inject = ['$scope', 'folders', 'Folder']

angular
  .module('app.courses')
  .controller('CourseFoldersCtrl', CourseFoldersCtrl)
