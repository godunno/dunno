DunnoApp = angular.module('DunnoApp')

EventCtrl = ($scope, Event, $location, $routeParams, Utils, DateUtils)->
  window.s = $scope
  angular.extend($scope, Utils)
  angular.extend($scope, DateUtils)

  $scope.event = new Event()
  $scope.event.course_id = $routeParams.course_id
  generateOrderable = (list)->
    list = list.sort (a,b)-> a.order - b.order
    last = list[list.length - 1]
    if last?
      order = last.order + 1
    else
      order = 1
    { order: order }

  $scope.newTopic = generateOrderable($scope.event.topics)
  $scope.newPersonalNote = generateOrderable($scope.event.personal_notes)

  formatToView = (event)->
      start_time = $scope.asDate(event.start_at)
      end_time   = $scope.asDate(event.end_at)

      event.date       = $scope.formattedDate(start_time, 'dd/MM/yyyy')
      event.start_time = $scope.formattedDate(start_time, 'HH:mm')
      event.end_time   = $scope.formattedDate(end_time,   'HH:mm')
      event

  formatFromView = (event)->
    # convert from brazilian locale
    date       = event.date.split("/").reverse().join("/")
    start_time = event.start_time
    end_time   = event.end_time

    event.start_at = Date.parse("#{date} #{start_time}")
    event.end_at   = Date.parse("#{date} #{end_time}")
    event

  # TODO: extract this get -> then -> assign to a service
  if $routeParams.id
    Event.get(uuid: $routeParams.id).then (event)->
      $scope.event = formatToView(event)
      $scope.newTopic = generateOrderable(event.topics)
      $scope.newPersonalNote = generateOrderable(event.personal_notes)

  for collection, i in ['topics', 'personal_notes'] #, 'thermometers', 'polls', 'medias']
    $scope.event[collection] ?= []
  #$scope.media_categories = ['image', 'video', 'audio']
  #$scope.media_types = [{value: 'url', name: 'URL'}, {value: 'file', name: 'File'}]

  $scope.save = (event)->
    event = formatFromView(event)
    event.save().then ->
      $location.path '#/events'
  $scope.addTopic = ->
    topics = $scope.event.topics
    $scope.newItem(topics, $scope.newTopic)
    $scope.newTopic = generateOrderable(topics)
  $scope.addPersonalNote = ->
    personal_notes = $scope.event.personal_notes
    $scope.newItem(personal_notes, $scope.newPersonalNote)
    $scope.newPersonalNote = generateOrderable(personal_notes)

EventCtrl.$inject = ['$scope', 'Event', '$location', '$routeParams', 'Utils', 'DateUtils']
DunnoApp.controller 'EventCtrl', EventCtrl
