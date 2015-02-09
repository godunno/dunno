DunnoApp = angular.module('DunnoApp')

MediasIndexCtrl = ($scope, Media, Utils)->

  $scope.search = { type: "all" }

  $scope.fetch = (options = {})->
    $scope.$emit('wholePageLoading', Media.search(q: $scope.search.q, page: options["page"]).then (response)->
      $scope.medias = response.medias
      $scope.previous_page = response.previous_page
      $scope.current_page = response.current_page
      $scope.next_page = response.next_page
    )

  $scope.fetch()

  $scope.clearSearch = ->
    $scope.search.q = ""
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

  $scope.removeMedia = (media)->
    if confirm("Deseja remover este anexo? Ele também será removida dos diários. Esta operação não poderá ser desfeita.")
      media.remove().then ->
        Utils.remove($scope.medias, media)

MediasIndexCtrl.$inject = ['$scope', 'Media', 'Utils']
DunnoApp.controller 'MediasIndexCtrl', MediasIndexCtrl
