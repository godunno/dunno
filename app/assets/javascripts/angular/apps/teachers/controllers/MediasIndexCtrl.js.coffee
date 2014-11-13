DunnoApp = angular.module('DunnoApp')

MediasIndexCtrl = ($scope, Media)->

  Media.query().then (medias)->
    $scope.medias = medias

  $scope.search = { type: "all" }

  # TODO: get the count from the server
  $scope.countType = (list, type)->
    return 0 unless list?
    return list.length if type == 'all'
    list.filter((item)-> item.type == type).length

MediasIndexCtrl.$inject = ['$scope', 'Media']
DunnoApp.controller 'MediasIndexCtrl', MediasIndexCtrl
