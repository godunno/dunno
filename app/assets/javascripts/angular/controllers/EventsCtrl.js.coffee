DunnoApp = angular.module('DunnoApp')

EventCtrl = ($scope, Event, $location, $routeParams, Utils)->
  angular.extend($scope, Utils)

  $scope.event = new Event()
  # TODO: extract this get -> then -> assign to a service
  if $routeParams.id
    $scope.event = Event.get(uuid: $routeParams.id)
    $scope.event.then (event)->
      $scope.event = event

  $scope.media_categories = ['image', 'video', 'audio']
  $scope.media_types = [{value: 'url', name: 'URL'}, {value: 'file', name: 'File'}]

  $scope.save = (event)->
    event['teste[]'] = event.medias
    event.save().then ->
      $location.path '#/events'
EventCtrl.$inject = ['$scope', 'Event', '$location', '$routeParams', 'Utils']
DunnoApp.controller 'EventCtrl', EventCtrl
