DunnoApp = angular.module('DunnoApp')
DunnoAppStudent = angular.module('DunnoAppStudent')

MediaSearcher = (Media)->
  @inject = ($scope)->
    $scope.search = { type: "all" }

    $scope.fetch = (event)->
      event.preventDefault() if event?
      $scope.$emit('wholePageLoading', Media.search(q: $scope.search.q).then (response)->
        $scope.medias = response.medias
        $scope.next_page = response.next_page
      )

    $scope.searchBy = (tag)->
      $scope.search.q = tag
      $scope.fetch()

    $scope.paginate = (page)->
      $scope.loadingNextPage = Media.search(q: $scope.search.q, page: page).then (response)->
        $scope.medias = ($scope.medias || []).concat response.medias
        $scope.next_page = response.next_page

    $scope.clearSearch = ->
      $scope.search.q = ""
      $scope.fetch()

    $scope.format_media_url = (media)->
      return media.filename if media.type == "file"

      parser = document.createElement('a')
      parser.href = media.url
      parser.hostname

  @

MediaSearcher.$inject = ['Media']

DunnoApp.service 'MediaSearcher', MediaSearcher
DunnoAppStudent.service 'MediaSearcher', MediaSearcher
