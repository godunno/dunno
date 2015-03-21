DunnoApp = angular.module('DunnoApp')

EventCtrl = (
  $scope,
  $routeParams,
  $interval,
  $window,
  $q,
  Event,
  Utils,
  DateUtils,
  NavigationGuard,
  AUTOSAVE_INTERVAL)->

  angular.extend($scope, Utils)
  angular.extend($scope, DateUtils)

  initializeEvent = (event)->
    $scope.event = event
    $scope.$broadcast('initializeEvent')

  initializeEvent(new Event())
  $scope.event.course_id = $routeParams.course_id

  # TODO: extract this get -> then -> assign to a service
  if $routeParams.id
    $scope.$emit('wholePageLoading', Event.get(uuid: $routeParams.id).then (event)->
      initializeEvent(event)
    )

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
    $scope.event_form.topic_description?.$dirty ||
    $scope.event_form.topic_private?.$dirty ||
    $scope.event_form.topic_media_url?.$dirty ||
    $scope.event_form.topic_media_file?.$dirty ||
    $scope.event_form.topic_media_id?.$dirty

  $scope.saveButtonDisabled = ->
    unsavedItems() ||
      anyEditing($scope.event.topics) ||
      $scope.isSaving ||
      $scope.event_form.$pristine

  $scope.save = (event)->
    $scope.isSaving = true
    deferred = $q.defer()
    event.save().then(->
      initializeEvent(event)
      $scope.isSaving = false
      $scope.event_form.$setPristine()
      deferred.resolve()
    ).catch(-> deferred.reject())
    deferred.promise

  $scope.courseLocation = (event)->
    return unless event? && event.course?
    "#courses/#{event.course.uuid}?month=#{event.start_at}"

  $scope.finish = (event)->
    $scope.save(event).then ->
      $window.location.href = $scope.courseLocation(event)

  $scope.updateItem = ($event, editingItem, item)->
    $event.preventDefault()
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

  $scope.setPrivateTopicsVisibility = (visible)->
    $scope.showPrivateTopics = visible

EventCtrl.$inject = ['$scope', '$routeParams', '$interval', '$window', '$q', 'Event', 'Utils', 'DateUtils', 'NavigationGuard', 'AUTOSAVE_INTERVAL']
DunnoApp.controller 'EventCtrl', EventCtrl
