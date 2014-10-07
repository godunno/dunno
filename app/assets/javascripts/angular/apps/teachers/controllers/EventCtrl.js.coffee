DunnoApp = angular.module('DunnoApp')

EventCtrl = ($scope, Event, $location, $routeParams, Utils, DateUtils, NavigationGuard)->
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

    event.start_at = new Date(Date.parse("#{date} #{start_time}")).toISOString()
    event.end_at   = new Date(Date.parse("#{date} #{end_time}")).toISOString()
    event

  # TODO: extract this get -> then -> assign to a service
  if $routeParams.id
    Event.get(uuid: $routeParams.id).then (event)->
      $scope.event = formatToView(event)
      $scope.newTopic = generateOrderable(event.topics)
      $scope.newPersonalNote = generateOrderable(event.personal_notes)

  for collection, i in ['topics', 'personal_notes']
    $scope.event[collection] ?= []

  $scope.addTopic = ($event)->
    $event.preventDefault()
    topics = $scope.event.topics
    $scope.newItem(topics, $scope.newTopic)
    $scope.newTopic = generateOrderable(topics)
  $scope.addPersonalNote = ($event)->
    $event.preventDefault()
    personal_notes = $scope.event.personal_notes
    $scope.newItem(personal_notes, $scope.newPersonalNote)
    $scope.newPersonalNote = generateOrderable(personal_notes)

  confirm_if_dirty = (event)->
    if $scope.event_form.$dirty
      "Algumas alterações ainda não foram salvas. Deseja continuar?"
  NavigationGuard.registerGuardian(confirm_if_dirty)
  $scope.$on '$destroy', -> NavigationGuard.unregisterGuardian(confirm_if_dirty)

  $scope.saving_message = ->
    if $scope.isSaving
      "Salvando..."
    else if $scope.event_form.$dirty
      "Salvar"
    else
      "Salvo"

  $scope.cannot_save = ->
    $scope.isSaving || $scope.event_form.$pristine

  $scope.save = (event)->
    event = formatFromView(event)
    run = ->
      $scope.isSaving = true
      event.save().then ->
        $scope.isSaving = false
        $scope.event_form.$setPristine()
        $location.path '#/events'
    if $scope.newTopic.description? || $scope.newPersonalNote.description?
      if !$scope.$emit('$locationChangeStart').defaultPrevented
        run()
    else
      run()


EventCtrl.$inject = ['$scope', 'Event', '$location', '$routeParams', 'Utils', 'DateUtils', 'NavigationGuard']
DunnoApp.controller 'EventCtrl', EventCtrl
