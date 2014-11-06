DunnoApp = angular.module('DunnoApp')

EventCtrl = (
  $scope,
  Event,
  $location,
  $routeParams,
  $interval,
  Utils,
  DateUtils,
  NavigationGuard,
  AUTOSAVE_INTERVAL)->

  angular.extend($scope, Utils)
  angular.extend($scope, DateUtils)

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
    $scope.$broadcast('initializeEvent')

  initializeEvent(new Event())
  $scope.event.course_id = $routeParams.course_id

  # TODO: extract this get -> then -> assign to a service
  if $routeParams.id
    Event.get(uuid: $routeParams.id).then (event)->
      initializeEvent(event)

  $scope.saveButtonMessage = ->
    if $scope.isSaving
      "Salvando..."
    else if !$scope.saveButtonDisabled()
      "Salvar"
    else
      "Salvo"

  anyEditing = (list)->
    !!list.filter((item)-> $scope.isEditing(item)).length

  unsavedItems = ->
    $scope.event_form.topic.$dirty ||
    $scope.event_form.topic_media_url.$dirty ||
    $scope.event_form.topic_media_file.$dirty ||
    $scope.event_form.personal_note.$dirty

  $scope.saveButtonDisabled = ->
    unsavedItems() ||
      anyEditing($scope.event.topics) ||
      anyEditing($scope.event.personal_notes) ||
      $scope.isSaving ||
      $scope.event_form.$pristine

  $scope.save = (event)->
    event = formatFromView(event)
    $scope.isSaving = true
    event.save().then ->
      initializeEvent(event)
      $scope.isSaving = false
      $scope.event_form.$setPristine()

  $scope.updateItem = (editingItem, item)->
    angular.copy(editingItem, item)
    item._editing = false

  $scope.isEditing = (item)-> !!item._editing
  $scope.editItem = (item, editingItem)->
    angular.copy(item, editingItem)
    item._editing = true

  autosave = $interval(
    -> $scope.save($scope.event) if !$scope.saveButtonDisabled()
    AUTOSAVE_INTERVAL)
  checkDirty = (event)->
    if $scope.event_form.$dirty || unsavedItems()
      "Algumas alterações ainda não foram efetuadas. Deseja continuar?"
  NavigationGuard.registerGuardian(checkDirty)
  $scope.$on '$destroy', ->
    NavigationGuard.unregisterGuardian(checkDirty)
    $interval.cancel(autosave)

EventCtrl.$inject = ['$scope', 'Event', '$location', '$routeParams', '$interval', 'Utils', 'DateUtils', 'NavigationGuard', 'AUTOSAVE_INTERVAL']
DunnoApp.controller 'EventCtrl', EventCtrl
