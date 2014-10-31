DunnoApp = angular.module('DunnoApp')

listCtrl = ($scope, Media, Utils)->
  angular.extend($scope, Utils)

  list = -> $scope.event[$scope.collection]

  generateOrderable = (list)->
    list = list.sort (a,b)-> a.order - b.order
    last = list[list.length - 1]
    if last?
      order = last.order + 1
    else
      order = 1
    { order: order }

  generateOrderableItem = ->
    $scope.newListItem = generateOrderable(list())
    $scope.removeMedia($scope.newListItem)

  $scope.$on 'initializeEvent', ->
    generateOrderableItem()
    list().sort (a,b)-> a.order - b.order

  $scope.addItem = ($event)->
    $event.preventDefault()
    unless $scope.newListItem._submittingMedia
      $scope.newItem(list(), $scope.newListItem)
      generateOrderableItem()
      $scope.save($scope.event)

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
    stop: ->
      for item, i in $scope.event[collection]
        item.order = i + 1
      $scope.save($scope.event)

  $scope.submitMedia = (item)->
    $scope.removeMedia(item)
    item._submittingMedia = true
    $scope.$broadcast("progress.start")
    $scope.$broadcast("progress.setValue", "100%")

    # TODO: Extract semaphore to service
    semaphore = 2
    stopProgressBar = ->
      semaphore -= 1
      $scope.$broadcast("progress.stop") if semaphore <= 0

    media = new Media(item.media)
    $scope.preview = { title: item.media.url }
    media.preview().then((preview)->
      $scope.preview = preview
    ).finally(->stopProgressBar())

    media.save().then((media)->
      item.media_id = media.id
    ).finally(->
      item._submittingMedia = false
      stopProgressBar()
    )

  $scope.removeMedia = (item)->
    item.media_id = null
    $scope.preview = null

  $scope.imageSrc = (src)-> src || "//:0"

listCtrl.$inject = ['$scope', 'Media', 'Utils']
DunnoApp.controller 'listCtrl', listCtrl

DunnoApp.directive 'eventList', ->
  restrict: 'A'
  scope: true
  controller: 'listCtrl'
  link: (scope, element, attrs)->
    scope.collection = attrs.eventList

