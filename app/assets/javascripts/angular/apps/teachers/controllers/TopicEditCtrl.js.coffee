DunnoApp = angular.module('DunnoApp')

TopicEditCtrl = ($scope, Utils)->
  $scope.isEditing = (topic) -> !!topic._editing

  $scope.startEditing = (topic) ->
    topic._editing = true
    $scope.$emit('startEditing')

  $scope.save = (topic) ->
    topic.save()

  $scope.finishEditing = (topic) ->
    topic._editing = false
    topic.save().then ->
      $scope.$emit('finishEditing')

  # TODO: Add to the next event's topics list.
  # TODO: Loading
  $scope.transferTopic = (topic)->
    return unless confirm("Deseja transferir esse topic? Essa operação não poderá ser desfeita.")
    topic.transfer().then ->
      $scope.$emit('transferTopic', topic)

  # TODO: Loading
  $scope.removeTopic = (topic)->
    return unless confirm("Deseja remover esse topic? Essa operação não poderá ser desfeita.")
    topic.remove().then ->
      $scope.$emit('removeTopic', topic)

  $scope.canTransferTopic = (topic, event)->
    !Utils.newRecord(topic) && !!event.next

TopicEditCtrl.$inject = ['$scope', 'Utils']
DunnoApp.controller 'TopicEditCtrl', TopicEditCtrl
