DunnoApp = angular.module('DunnoApp')

TopicEditCtrl = ($scope, Utils)->
  $scope.isEditing = (topic) -> !!topic._editing

  initialize = ->
    $scope.editingTopic = {}
  initialize()

  reset = ->
    $scope.$emit('finishEditing')
    initialize()

  $scope.save = (topic) ->
    topic.save()

  $scope.startEditing = (topic) ->
    angular.extend $scope.editingTopic, topic
    topic._editing = true
    $scope.$emit('startEditing')

  $scope.finishEditing = (topic) ->
    angular.extend topic, $scope.editingTopic
    topic._editing = false
    topic.save().then reset

  $scope.cancelEditing = (topic) ->
    topic._editing = false
    reset()

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
