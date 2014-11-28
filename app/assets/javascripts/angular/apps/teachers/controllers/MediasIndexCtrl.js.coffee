DunnoApp = angular.module('DunnoApp')

MediasIndexCtrl = ($scope, Media)->

  $scope.search = { type: "all" }

  $scope.fetch = (options = {})->
    Media.configure(fullResponse: true)
    Media.query(q: $scope.search.q, page: options["page"]).then (response)->
      $scope.medias = response[0].data
      $scope.previous_page = response[0].originalData.previous_page
      $scope.current_page = response[0].originalData.current_page
      $scope.next_page = response[0].originalData.next_page
      Media.configure(fullResponse: false)

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
