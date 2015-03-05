DunnoApp = angular.module('DunnoApp')
DunnoAppStudent = angular.module('DunnoAppStudent')

MediaSearcher = (Media)->
  @inject = ($scope)->
    $scope.search = { type: "all" }

    $scope.fetch = (options = {})->
      if options.preventDefault?
        (event = options).preventDefault()
        options = {}
      $scope.$emit('wholePageLoading', Media.search(q: $scope.search.q, page: options["page"]).then (response)->
        $scope.medias = response.medias
        $scope.previous_page = response.previous_page
        $scope.current_page = response.current_page
        $scope.next_page = response.next_page
      )

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
