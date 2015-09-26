TopicEditCtrl = ($scope, Utils) ->
  $scope.isEditing = -> !!$scope._editing

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
    $scope._editing = true
    $scope.$emit('startEditing')

  $scope.finishEditing = (topic) ->
    angular.extend topic, $scope.editingTopic
    $scope.submitting = topic.save().then ->
      $scope._editing = false
      reset()

  $scope.cancelEditing = (topic) ->
    $scope._editing = false
    reset()

  $scope.transferTopic = (topic) ->
    return unless confirm("Você tem certeza que deseja mover este conteúdo para a próxima aula?")
    topic.transfer().then ->
      $scope.$emit('transferTopic', topic)

  $scope.removeTopic = (topic) ->
    return unless confirm("Você tem certeza que deseja remover este conteúdo?")
    topic.remove().then ->
      $scope.$emit('removeTopic', topic)

  $scope.canTransferTopic = (topic, event) ->
    !Utils.newRecord(topic) && !!event.next

TopicEditCtrl.$inject = ['$scope', 'Utils']

angular
  .module('app.lessonPlan')
  .controller('TopicEditCtrl', TopicEditCtrl)
