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

  # TODO: extract this get -> then -> assign to a service
  $scope.$emit('wholePageLoading', Event.get(uuid: $routeParams.id).then (event)->
    initializeEvent(event)
  )

  initializeEvent = (event)->
    $scope.event = event
    $scope.$broadcast('initializeEvent')

  $scope.saveButtonMessage = ->
    if $scope.isSaving
      "Salvando..."
    else if !$scope.saveButtonDisabled()
      "Salvar"
    else
      "Salvo"

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

  #### Lista de tópicos
  $scope.showPrivateTopics = true
  $scope.setPrivateTopicsVisibility = (visible)->
    $scope.showPrivateTopics = visible
  ####

  #### Novo tópico
  unsavedItems = ->
    $scope.event_form.topic_text_description?.$dirty ||
    $scope.event_form.topic_file_description?.$dirty ||
    $scope.event_form.topic_url_description?.$dirty ||
    $scope.event_form.topic_private?.$dirty ||
    $scope.event_form.topic_media_url?.$dirty ||
    $scope.event_form.topic_media_file?.$dirty ||
    $scope.event_form.topic_media_id?.$dirty
  ####

  edits = 0

  anyEditing = -> edits > 0

  $scope.$on 'startEditing', ->
    edits++

  $scope.$on 'finishEditing', ->
    edits--

  #### Depende de novo tópico
  $scope.saveButtonDisabled = ->
    unsavedItems() ||
      anyEditing() ||
      $scope.isSaving ||
      $scope.event_form.$pristine
  ####

EventCtrl.$inject = ['$scope', '$routeParams', '$interval', '$window', '$q', 'Event', 'Utils', 'DateUtils', 'NavigationGuard', 'AUTOSAVE_INTERVAL']
DunnoApp.controller 'EventCtrl', EventCtrl
