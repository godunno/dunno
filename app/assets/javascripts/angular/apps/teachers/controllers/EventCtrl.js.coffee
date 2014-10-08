# When should we ask confirmation?
#
# - When the form is dirty and the user wants
#   to navigate to another page/route.
#
# - When the user has filled a new item (topic or
#   personal note) and clicked the save button
#   but didn't insert it to its list.

DunnoApp = angular.module('DunnoApp')

EventCtrl = ($scope, Event, $location, $routeParams, Utils, DateUtils, NavigationGuard)->
  angular.extend($scope, Utils)
  angular.extend($scope, DateUtils)

  generateOrderable = (list)->
    list = list.sort (a,b)-> a.order - b.order
    last = list[list.length - 1]
    if last?
      order = last.order + 1
    else
      order = 1
    { order: order }

  # TODO: extract to directive
  formatToView = (event)->
    start_time = $scope.asDate(event.start_at)
    end_time   = $scope.asDate(event.end_at)

    event.date       = $scope.formattedDate(start_time, 'dd/MM/yyyy')
    event.start_time = $scope.formattedDate(start_time, 'HH:mm')
    event.end_time   = $scope.formattedDate(end_time,   'HH:mm')
    event

  # TODO: extract to directive
  formatFromView = (event)->
    # convert from brazilian locale
    date       = event.date.split("/").reverse().join("/")
    start_time = event.start_time
    end_time   = event.end_time

    event.start_at = new Date(Date.parse("#{date} #{start_time}")).toISOString()
    event.end_at   = new Date(Date.parse("#{date} #{end_time}")).toISOString()
    event

  initializeEvent = (event)->
    $scope.event = formatToView(event)
    $scope.newTopic = generateOrderable($scope.event.topics)
    $scope.newPersonalNote = generateOrderable($scope.event.personal_notes)
    for collection, i in ['topics', 'personal_notes']
      $scope.event[collection] ?= []

  initializeEvent(new Event())
  $scope.event.course_id = $routeParams.course_id

  # TODO: extract this get -> then -> assign to a service
  if $routeParams.id
    Event.get(uuid: $routeParams.id).then (event)->
      initializeEvent(event)

  addItem = ($event, list, itemName)->
    $event.preventDefault()
    $scope.newItem(list, $scope[itemName])
    $scope[itemName] = generateOrderable(list)

  $scope.addTopic = ($event)->
    addItem($event, $scope.event.topics, 'newTopic')
  $scope.addPersonalNote = ($event)->
    addItem($event, $scope.event.personal_notes, 'newPersonalNote')

  confirmIfDirty = (event)->
    if $scope.event_form.$dirty
      "Algumas alterações ainda não foram efetuadas. Deseja continuar?"
  NavigationGuard.registerGuardian(confirmIfDirty)
  $scope.$on '$destroy', -> NavigationGuard.unregisterGuardian(confirmIfDirty)

  $scope.saveButtonMessage = ->
    if $scope.isSaving
      "Salvando..."
    else if $scope.event_form.$dirty
      "Salvar"
    else
      "Salvo"

  $scope.saveButtonDisabled = ->
    $scope.isSaving || $scope.event_form.$pristine

  $scope.save = (event)->
    event = formatFromView(event)
    run = ->
      $scope.isSaving = true
      event.save().then ->
        $scope.isSaving = false
        $scope.event_form.$setPristine()
        initializeEvent(event)

    console.log $scope.newPersonalNote
    unsavedItems = $scope.newTopic.description || $scope.newPersonalNote.content
    if unsavedItems
      confirmSave = !$scope.$emit('$locationChangeStart').defaultPrevented
      if confirmSave
        run()
    else
      run()

EventCtrl.$inject = ['$scope', 'Event', '$location', '$routeParams', 'Utils', 'DateUtils', 'NavigationGuard']
DunnoApp.controller 'EventCtrl', EventCtrl
