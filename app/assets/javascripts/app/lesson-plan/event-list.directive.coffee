EventListCtrl = ($scope, $analytics, $rootScope, Media, Utils) ->
  list = -> $scope.event[$scope.collection]

  $scope.sortableOptions =
    orderChanged: ->
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

EventListCtrl.$inject = ['$scope', '$analytics', '$rootScope', 'Media', 'Utils']

link = (scope, element, attrs) ->
  scope.collection = attrs.eventList

eventList = ->
  restrict: 'A'
  scope: true
  controller: EventListCtrl
  link: link

angular
  .module('app.lessonPlan')
  .directive('eventList', eventList)
