AddFromMediaCtrl = ($scope, MediaSearcher) ->
  MediaSearcher.extend($scope)

  $scope.perPage = 3

  $scope.fetch()

  reset = ->
    $scope.result = {}

  reset()

  $scope.selectMedia = ->
    $scope.$broadcast 'newMedia', $scope.result.media

  $scope.$on 'createdTopic', reset
  $scope.$on 'cancelTopic', reset

AddFromMediaCtrl.$inject = ['$scope', 'MediaSearcher']

angular
  .module('app.lessonPlan')
  .controller('AddFromMediaCtrl', AddFromMediaCtrl)
