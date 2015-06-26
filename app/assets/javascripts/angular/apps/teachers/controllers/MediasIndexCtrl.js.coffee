DunnoApp = angular.module('DunnoApp')

MediasIndexCtrl = ($scope, searchResult, MediaSearcher, Utils) ->
  MediaSearcher.extend($scope)

  $scope.medias = searchResult.medias
  $scope.next_page = searchResult.next_page

  $scope.showTutorial = -> !$scope.medias || (noMedias() && $scope.media_search.q.$untouched)

  # TODO: get the count from the server
  $scope.countType = (list, type)->
    return 0 unless list?
    return list.length if type == 'all'
    list.filter((item)-> item.type == type).length

  $scope.isEditing = (media) -> !!media._editing
  $scope.startEditing = (media) -> media._editing = true
  $scope.updateMedia = (media)->
    media._editing = false
    media.updateTagList()
    media.update()

  $scope.removeMedia = (media)->
    if confirm("Deseja remover este anexo? Ele também será removida dos diários. Esta operação não poderá ser desfeita.")
      media.remove().then ->
        Utils.remove $scope.medias, media
        $scope.fetch() if noMedias()

  noMedias = ->
    $scope.medias.length == 0


MediasIndexCtrl.$inject = ['$scope', 'searchResult', 'MediaSearcher', 'Utils']
DunnoApp.controller 'MediasIndexCtrl', MediasIndexCtrl
