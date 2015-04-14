DunnoApp = angular.module('DunnoApp')

TopicEditCtrl = ($scope, Utils)->
  $scope.isEditing = (item) -> !!item._editing

  $scope.startEditing = (item) ->
    item._editing = true
    $scope.$emit('startEditing')

  $scope.finishEditing = (item) ->
    item._editing = false
    $scope.$emit('finishEditing')

  $scope.transferItem = (topic)->
    return unless confirm("Deseja transferir esse item? Essa operação não poderá ser desfeita.")
    topic.transfer().then ->
      $scope.$emit('transferTopic', topic)

  $scope.removeItem = (list, item)->
    return unless confirm("Deseja remover esse item? Essa operação não poderá ser desfeita.")
    Utils.destroy(item)
    # TODO: Add to the next event's topics list.
    Utils.remove(list, item)

  $scope.canTransferItem = (item, event)->
    !Utils.newRecord(item) && !!event.next

TopicEditCtrl.$inject = ['$scope', 'Utils']
DunnoApp.controller 'TopicEditCtrl', TopicEditCtrl
