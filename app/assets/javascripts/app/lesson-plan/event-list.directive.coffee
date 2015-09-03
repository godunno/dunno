app.lessonPlan = angular.module('app.lessonPlan')

listCtrl = ($scope, $analytics, $rootScope, Media, Utils)->
  list = -> $scope.event[$scope.collection]

  $scope.sortableOptions = (collection)->
    handle: '.handle'
    containment: 'parent'
    stop: ->
      $analytics.eventTrack "Item Drag 'n Drop",
        eventUuid: $scope.event.uuid,
        courseUuid: $scope.event.course.uuid
      $scope.save($scope.event)

  removeTopic = ($event, topic) ->
    Utils.remove(list(), topic)

  addToList = ($event, topic) ->
    list().unshift(topic)

  $scope.$on 'transferTopic', removeTopic
  $scope.$on 'removeTopic', removeTopic
  $scope.$on 'createdTopic', addToList

listCtrl.$inject = ['$scope', '$analytics', '$rootScope', 'Media', 'Utils']
app.lessonPlan.controller 'listCtrl', listCtrl

# TODO: Use as controller directly
app.lessonPlan.directive 'eventList', ->
  restrict: 'A'
  scope: true
  controller: 'listCtrl'
  link: (scope, element, attrs)->
    scope.collection = attrs.eventList

