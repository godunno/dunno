DunnoApp = angular.module('DunnoApp')

TopicEditCtrl = ($scope, Utils)->
  $scope.isEditing = (topic) -> !!topic._editing

  $scope.startEditing = (topic) ->
    topic._editing = true
    $scope.$emit('startEditing')

  $scope.finishEditing = (topic) ->
    topic._editing = false
    topic.save().then ->
      $scope.$emit('finishEditing')

  $scope.transferTopic = (topic)->
    return unless confirm("Deseja transferir esse topic? Essa operação não poderá ser desfeita.")
    topic.transfer().then ->
      $scope.$emit('transferTopic', topic)

  $scope.removeTopic = (list, topic)->
    return unless confirm("Deseja remover esse topic? Essa operação não poderá ser desfeita.")
    Utils.destroy(topic)
    # TODO: Add to the next event's topics list.
    Utils.remove(list, topic)

  $scope.canTransfertopic = (topic, event)->
    !Utils.newRecord(topic) && !!event.next

TopicEditCtrl.$inject = ['$scope', 'Utils']
DunnoApp.controller 'TopicEditCtrl', TopicEditCtrl
