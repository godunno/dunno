DunnoApp = angular.module('DunnoApp')

MediasIndexCtrl = ($scope, Media)->

  $scope.search = { type: "all" }

  $scope.fetch = ->
    Media.query(q: $scope.search.q).then (medias)->
      $scope.medias = medias

  $scope.fetch()

  # TODO: get the count from the server
  $scope.countType = (list, type)->
    return 0 unless list?
    return list.length if type == 'all'
    list.filter((item)-> item.type == type).length

  $scope.format_media_url = (media)->
    return media.filename if media.type == "file"

    parser = document.createElement('a')
    parser.href = media.url
    parser.hostname.replace(/^www\./, '')

  $scope.updateMedia = (media)->
    media.update_tag_list()
    media.update()

MediasIndexCtrl.$inject = ['$scope', 'Media']
DunnoApp.controller 'MediasIndexCtrl', MediasIndexCtrl
