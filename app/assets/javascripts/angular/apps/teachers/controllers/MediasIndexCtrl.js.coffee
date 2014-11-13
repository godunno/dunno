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

  $scope.format_media_url = (media)->
    return media.preview.title if media.type == "file"

    parser = document.createElement('a')
    parser.href = media.preview.url
    parser.hostname.replace(/^www\./, '')

MediasIndexCtrl.$inject = ['$scope', 'Media']
DunnoApp.controller 'MediasIndexCtrl', MediasIndexCtrl
