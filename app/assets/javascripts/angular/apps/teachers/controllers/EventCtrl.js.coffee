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
    $scope.$broadcast('initializeEvent', event)

  $scope.save = (event)->
    deferred = $q.defer()
    event.save().then(->
      initializeEvent(event)
      deferred.resolve()
    ).catch(-> deferred.reject())
    deferred.promise

  $scope.courseLocation = (event)->
    return unless event? && event.course?
    "#courses/#{event.course.uuid}?month=#{event.start_at}"

  $scope.finish = (event)->
    unless $scope.$emit('dunno.exit').defaultPrevented
      $scope.save(event).then ->
        $scope.event_form.$setPristine()
        $window.location.href = $scope.courseLocation(event)

  $scope.publish = (event)->
    event.status = 'published'
    $scope.finish(event)

  checkDirty = (event)->
    if anyEditing() || unsavedItems()
      "Algumas alterações ainda não foram efetuadas. Deseja continuar?"
  NavigationGuard.registerGuardian(checkDirty)
  $scope.$on '$destroy', ->
    NavigationGuard.unregisterGuardian(checkDirty)

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

EventCtrl.$inject = ['$scope', '$routeParams', '$interval', '$window', '$q', 'Event', 'Utils', 'DateUtils', 'NavigationGuard', 'AUTOSAVE_INTERVAL']
DunnoApp.controller 'EventCtrl', EventCtrl
