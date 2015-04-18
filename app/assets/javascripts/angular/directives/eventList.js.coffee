DunnoApp = angular.module('DunnoApp')

listCtrl = ($scope, $analytics, $rootScope, Media, Utils)->
  list = -> $scope.event[$scope.collection]

  #### Novo tópico
  #$scope.addItem = ($event)->
  #  $event.preventDefault() if $event?
  #  run = ->
  #    unless $scope.newListItem.description || $scope.newListItem.media_id
  #      return alert("Não é possível adicionar item sem texto ou anexo.")
  #    $analytics.eventTrack 'Item Created',
  #      eventUuid: $scope.event.uuid,
  #      courseUuid: $scope.event.course.uuid
  #    list().unshift $scope.newListItem
  #    $rootScope.defaultTopicPrivacy = $scope.newListItem.personal
  #    $scope.resetNewItem()
  #    $scope.save($scope.event)
  #  if $scope._editingMediaUrl
  #    $scope.submitUrlMedia($scope.newListItem).then(run)
  #  else if !$scope.newListItem._submittingMedia
  #    run()

  #$scope.startUrlMediaEditing = ->
  #  $scope._editingMediaUrl = true

  #$scope.$on 'catalog-picker.selected', (_, media)->
  #  $analytics.eventTrack('Media Selected', type: media.type, title: media.title, eventUuid: $scope.event.uuid)
  #  $scope.newListItem.media = media
  #  $scope.newListItem.media_id = media.uuid

  #$scope.removeMedia = (item)->
  #  item.media?.remove()
  #  item.media_id = null
  #  item.media = null
  #  $scope.event_form.$setDirty()
  ####

  $scope.sortableOptions = (collection)->
    handle: '.handle'
    stop: ->
      $analytics.eventTrack "Item Drag 'n Drop",
        eventUuid: $scope.event.uuid,
        courseUuid: $scope.event.course.uuid
      $scope.save($scope.event)

  removeTopic = ($event, topic) ->
    Utils.remove(list(), topic)

  addToList = ($event, topic) ->
    list().unshift(topic)

  $scope.$on 'transferTopic', removeTopic
  $scope.$on 'removeTopic', removeTopic
  $scope.$on 'createdTopic', addToList

listCtrl.$inject = ['$scope', '$analytics', '$rootScope', 'Media', 'Utils']
DunnoApp.controller 'listCtrl', listCtrl

# TODO: Use as controller directly
DunnoApp.directive 'eventList', ->
  restrict: 'A'
  scope: true
  controller: 'listCtrl'
  link: (scope, element, attrs)->
    scope.collection = attrs.eventList

