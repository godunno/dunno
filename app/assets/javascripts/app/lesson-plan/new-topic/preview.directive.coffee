previewCtrl = ($scope) ->
  $scope.removeMedia = ->
    if confirm("Deseja remover este anexo? Essa operação não poderá ser desfeita.")
      $scope.$emit('removeMedia')

previewCtrl.$inject = ['$scope']

preview = ->
  restrict: 'E'
  controller: previewCtrl
  templateUrl: 'core/components/preview'
  scope:
    item: '='
    removable: '='

angular
  .module('app.lessonPlan')
  .directive('preview', preview)
