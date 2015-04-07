DunnoApp = angular.module('DunnoApp')

listCtrl = ($scope, $upload, $analytics, $rootScope, Media, Utils)->
  angular.extend($scope, Utils)

  list = -> $scope.event[$scope.collection]

  generateOrderable = (list)->
    list = list.sort (a,b)-> a.order - b.order
    last = list[list.length - 1]
    $rootScope.defaultTopicPrivacy ?= false
    if last?
      order = last.order + 1
    else
      order = 1
    { order: order, personal: $rootScope.defaultTopicPrivacy }

  $scope.resetNewItem = ->
    $scope.newListItem = generateOrderable(list())
    $scope.itemType = 'text'

  $scope.itemTypeDescription = ->
    {
      'text': 'texto',
      'file': 'arquivo',
      'url': 'link',
      'catalog': 'do catálogo'
    }[$scope.itemType]

  $scope.$on 'initializeEvent', ->
    $scope.resetNewItem()
    list().sort (a,b)-> a.order - b.order

  $scope.addItem = ($event)->
    $event.preventDefault() if $event?
    run = ->
      unless $scope.newListItem.description || $scope.newListItem.media_id
        return alert("Não é possível adicionar item sem texto ou anexo.")
      $analytics.eventTrack 'Item Created',
        eventUuid: $scope.event.uuid,
        courseUuid: $scope.event.course.uuid
      $scope.newItem(list(), $scope.newListItem)
      $rootScope.defaultTopicPrivacy = $scope.newListItem.personal
      $scope.resetNewItem()
      $scope.save($scope.event)
    if $scope._editingMediaUrl
      $scope.submitUrlMedia($scope.newListItem).then(run)
    else if !$scope.newListItem._submittingMedia
      run()

  $scope.transferItem = (list, item)->
    if confirm("Deseja transferir esse item? Essa operação não poderá ser desfeita.")
      item.transfer().then ->
        Utils.remove(list, item)

  $scope.removeItem = (list, item)->
    if confirm("Deseja remover esse item? Essa operação não poderá ser desfeita.")
      $scope.destroy(item)
      $scope.save($scope.event)
      Utils.remove(list, item)

  $scope.canTransferItem = (item)->
    !$scope.newRecord(item) && !$scope.newRecord($scope.event.next)

  $scope.sortableOptions = (collection)->
    handle: '.handle'
    stop: ->
      $analytics.eventTrack "Item Drag 'n Drop",
        eventUuid: $scope.event.uuid,
        courseUuid: $scope.event.course.uuid
      for item, i in $scope.event[collection]
        item.order = i + 1
      $scope.save($scope.event)

  submitMedia = (item, callback, showProgress)->
    return if item.media? && !confirm("Deseja substituir o anexo atual?")
    $scope.removeMedia(item)
    item._submittingMedia = true
    if showProgress
      $scope.$broadcast("progress.start")
    callback.then((response)->
      media = if response.data? # response may be wrapped
          response.data
        else if Array.isArray(response)
          response[0]
        else
          response
      $analytics.eventTrack('Media Created', type: media.type, title: media.title, eventUuid: $scope.event.uuid)
      item.media = media
      item.media_id = media.uuid
      item.description = media.title
    ).finally(->
      item._submittingMedia = false
      $scope.$broadcast("progress.stop")
    )

  $scope.startUrlMediaEditing = ->
    $scope._editingMediaUrl = true

  $scope.submitUrlMedia = (item)->
    $scope._editingMediaUrl = false
    media = new Media(url: item.media_url)
    $scope.submittingMediaPromise = promise = media.create()
    submitMedia item, promise
    promise

  $scope.submitFileMedia = (item, $files)->
    media = new Media()
    media.file = $files[0]
    promise = media.upload()

    # promise.then(success, failure, notify)
    promise.then(null, null, (evt)-> # notifying progress
      percentage = parseInt(100.0 * evt.loaded / evt.total)
      $scope.$broadcast("progress.setValue", "#{percentage}%")
    ).catch((response)->
      if response.error == 'too_large'
        alert 'O arquivo enviado é grande demais.'
      else
        alert 'Ocorreu um erro durante o envio do arquivo.'
    )
    submitMedia item, promise, true
    $scope.$broadcast("file.clean")

  $scope.$on 'catalog-picker.selected', (_, media)->
    $analytics.eventTrack('Media Selected', type: media.type, title: media.title, eventUuid: $scope.event.uuid)
    $scope.newListItem.media = media
    $scope.newListItem.media_id = media.uuid

  $scope.removeMedia = (item)->
    item.media?.remove()
    item.media_id = null
    item.media = null
    $scope.event_form.$setDirty()

listCtrl.$inject = ['$scope', '$upload', '$analytics', '$rootScope', 'Media', 'Utils']
DunnoApp.controller 'listCtrl', listCtrl

DunnoApp.directive 'eventList', ->
  restrict: 'A'
  scope: true
  controller: 'listCtrl'
  link: (scope, element, attrs)->
    scope.collection = attrs.eventList

