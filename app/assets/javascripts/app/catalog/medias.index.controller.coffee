MediasIndexCtrl = ($scope, searchResult, MediaSearcher, Utils) ->
  MediaSearcher.extend($scope)

  $scope.medias = searchResult.medias
  $scope.next_page = searchResult.next_page

  $scope.showTutorial = -> !$scope.medias || (noMedias() && $scope.search.q.$untouched)

  # TODO: get the count from the server
  $scope.countType = (list, type) ->
    return 0 unless list?
    return list.length if type == 'all'
    list.filter((item)-> item.type == type).length

  $scope.startEditing = (media) -> media._editing = true
  $scope.isEditing = (media) -> !!media._editing

  $scope.updateMedia = (media) ->
    media._editing = false
    media.updateTagList()
    media.update()

  $scope.removeMedia = (media)->
    if confirm("Deseja remover este conteúdo?
      \nAo remover um conteúdo do catálogo ele também será removido das suas aulas.
      \n\nATENÇÃO!
      \nEsta operação não poderá ser desfeita.")
      media.remove().then ->
        Utils.remove $scope.medias, media
        $scope.fetch() if noMedias()

  noMedias = ->
    $scope.medias.length == 0


MediasIndexCtrl.$inject = ['$scope', 'searchResult', 'MediaSearcher', 'Utils']

angular
  .module('DunnoApp')
  .controller('MediasIndexCtrl', MediasIndexCtrl)
