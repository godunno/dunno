DunnoApp = angular.module('DunnoApp')

listCtrl = ($scope, Utils)->
  angular.extend($scope, Utils)

  itemName = ->
    names = {
      "topics": "newTopic"
      "personal_notes": "newPersonalNote"
    }
    names[$scope.collection]

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
    $scope[itemName()] = generateOrderable(list())

  $scope.$on 'initializeEvent', ->
    generateOrderableItem()
    list().sort (a,b)-> a.order - b.order

  $scope.addItem = ($event)->
    $event.preventDefault()
    $scope.newItem(list(), $scope[itemName()])
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

listCtrl.$inject = ['$scope', 'Utils']
DunnoApp.controller 'listCtrl', listCtrl

DunnoApp.directive 'eventList', ->
  restrict: 'A'
  scope: true
  controller: 'listCtrl'
  link: (scope, element, attrs)->
    scope.collection = attrs.eventList

