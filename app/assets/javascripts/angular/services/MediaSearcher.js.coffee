DunnoApp = angular.module('DunnoApp')

MediaSearcher = (Media) ->
  @extend = ($scope) ->
    $scope.search = { type: "all" }

    $scope.fetch = (event) ->
      event.preventDefault() if event?
      $scope.$emit('wholePageLoading', $scope.searchMedia().then (response) =>
        $scope.medias = response.medias
        $scope.next_page = response.next_page
      )

    $scope.searchBy = (tag) ->
      $scope.search.q = tag.text
      $scope.fetch()

    $scope.paginate = (page) ->
      $scope.loadingNextPage = $scope.searchMedia(page).then (response) =>
        $scope.medias = ($scope.medias || []).concat response.medias
        $scope.next_page = response.next_page

    $scope.clearSearch = ->
      $scope.search.q = ""
      $scope.fetch()

    $scope.formatMediaUrl = (media) ->
      return media.filename if media.type == "file"

      parser = document.createElement('a')
      parser.href = media.url
      parser.hostname

    $scope.searchMedia = (page) ->
      Media.search(q: $scope.search.q, page: page, per_page: $scope.perPage)

  @

MediaSearcher.$inject = ['Media']

DunnoApp.service 'MediaSearcher', MediaSearcher
