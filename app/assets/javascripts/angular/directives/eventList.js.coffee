DunnoApp = angular.module('DunnoApp')

listCtrl = ($scope, Media, Utils, $upload) ->
  angular.extend($scope, Utils)

  list = -> $scope.event[$scope.collection]

  generateOrderable = (list) ->
    list = list.sort (a,b) -> a.order - b.order
    last = list[list.length - 1]
    if last?
      order = last.order + 1
    else
      order = 1
    { order: order }

  generateOrderableItem = ->
    $scope.newListItem = generateOrderable(list())

  $scope.$on 'initializeEvent', ->
    generateOrderableItem()
    list().sort (a,b) -> a.order - b.order

  $scope.addItem = ($event) ->
    $event.preventDefault() if $event?
    run = ->
      unless $scope.newListItem.description || $scope.newListItem.media_id
        return alert("Não é possível adicionar item sem texto ou anexo.")
      $scope.newItem(list(), $scope.newListItem)
      generateOrderableItem()
      $scope.save($scope.event)
    if $scope._editingMediaUrl
      $scope.submitUrlMedia($scope.newListItem).then(run)
    else if !$scope.newListItem._submittingMedia
      run()

  $scope.transferItem = (list, item) ->
    if confirm("Deseja transferir esse item? Essa operação não poderá ser desfeita.")
      item.transfer().then ->
        Utils.remove(list, item)

  $scope.removeItem = (list, item) ->
    if confirm("Deseja remover esse item? Essa operação não poderá ser desfeita.")
      $scope.destroy(item)
      $scope.save($scope.event)
      Utils.remove(list, item)

  $scope.canTransferItem = (item) ->
    !$scope.newRecord(item) && !$scope.newRecord($scope.event.next)

  $scope.sortableOptions = (collection) ->
    stop: ->
      for item, i in $scope.event[collection]
        item.order = i + 1
      $scope.save($scope.event)

  submitMedia = (item, callback, showProgress) ->
    return if item.media? && !confirm("Deseja substituir o anexo atual?")
    $scope.removeMedia(item)
    item._submittingMedia = true
    if showProgress?
      $scope.$broadcast("progress.start")
      showProgress(callback)
    callback.then((response) ->
      media = if response.data? # response may be wrapped
          response.data
        else if Array.isArray(response)
          response[0]
        else
          response
      item.media = media
      item.media_id = media.uuid
    ).finally(->
      item._submittingMedia = false
      $scope.$broadcast("progress.stop")
    )

  $scope.startUrlMediaEditing = ->
    $scope._editingMediaUrl = true

  $scope.submitUrlMedia = (item) ->
    $scope._editingMediaUrl = false
    media = new Media(url: item.media_url)
    $scope.submittingMediaPromise = promise = media.create()
    submitMedia item, promise
    promise

  $scope.submitFileMedia = (item, $files) ->
    media = new Media()
    media.file = $files[0]
    submitMedia item, media.upload(), (callback) ->
      callback.progress (evt) ->
        percentage = parseInt(100.0 * evt.loaded / evt.total)
        $scope.$broadcast("progress.setValue", "#{percentage}%")
    $scope.$broadcast("file.clean")

  $scope.removeMedia = (item) ->
    item.media_id = null
    item.media = null
    $scope.event_form.$setDirty()

DunnoApp.controller 'listCtrl', listCtrl

DunnoApp.directive 'eventList', ->
  restrict: 'A'
  scope: true
  controller: 'listCtrl'
  link: (scope, element, attrs) ->
    scope.collection = attrs.eventList

