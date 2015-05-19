describe "EventsIndexCtrl", ->
  beforeEach module('DunnoApp')
  beforeEach teacherAppMockDefaultRoutes

  $controller = null
  beforeEach ->
    inject (_$controller_) ->
      $controller = _$controller_

  it "assigns events", ->
    $scope = {}
    events = []
    $controller('EventsIndexCtrl', $scope: $scope, events: events)
    expect($scope.events).toBe(events)

  it "extends DateUtils", ->
    $scope = {}
    DateUtils = { key: 'value' }
    $controller('EventsIndexCtrl', $scope: $scope, events: [], DateUtils: DateUtils)
    expect($scope.key).toEqual('value')
