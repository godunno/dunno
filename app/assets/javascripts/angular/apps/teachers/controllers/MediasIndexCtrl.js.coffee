DunnoApp = angular.module('DunnoApp')

MediasIndexCtrl = ($scope, Media, Utils, MediaSearcher)->
  MediaSearcher.inject($scope)

  $scope.fetch()

  # TODO: get the count from the server
  $scope.countType = (list, type)->
    return 0 unless list?
    return list.length if type == 'all'
    list.filter((item)-> item.type == type).length

  $scope.updateMedia = (media)->
    media.update_tag_list()
    media.update()

  $scope.removeMedia = (media)->
    if confirm("Deseja remover este anexo? Ele também será removida dos diários. Esta operação não poderá ser desfeita.")
      media.remove().then ->
        last = $scope.medias.length == 1
        page = if last then $scope.previous_page else $scope.current_page
        $scope.fetch(page: page)

MediasIndexCtrl.$inject = ['$scope', 'Media', 'Utils', 'MediaSearcher']
DunnoApp.controller 'MediasIndexCtrl', MediasIndexCtrl
