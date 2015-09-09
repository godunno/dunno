MediaSearcher = (Media) ->
  @extend = ($scope) ->
    query = { q: "" }

    $scope.fetch = (event) ->
      event.preventDefault() if event?
      $scope.$emit('wholePageLoading', $scope.searchMedia().then (response) ->
        $scope.medias = response.medias
        $scope.next_page = response.next_page
      )

    $scope.search = (q) ->
      query.q = q
      $scope.fetch()

    $scope.clearSearch = ->
      $scope.search("")

    $scope.paginate = (page) ->
      $scope.loadingNextPage = $scope.searchMedia(page).then (response) ->
        $scope.medias = ($scope.medias || []).concat response.medias
        $scope.next_page = response.next_page

    $scope.formatMediaUrl = (media) ->
      return media.filename if media.type == "file"

      parser = document.createElement('a')
      parser.href = media.url
      parser.hostname

    $scope.searchMedia = (page) ->
      Media.search(q: query.q, page: page, per_page: $scope.perPage)

  @

MediaSearcher.$inject = ['Media']

angular
  .module('app.core')
  .service('MediaSearcher', MediaSearcher)
