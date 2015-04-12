DunnoApp = angular.module('DunnoApp')
DunnoAppStudent = angular.module('DunnoAppStudent')

MediaSearcher = (Media) ->
  @search = { type: "all" }

  @fetch = (event) ->
    event.preventDefault() if event?
    @$emit('wholePageLoading', @searchMedia().then (response) =>
      @medias = response.medias
      @next_page = response.next_page
    )

  @searchBy = (tag) ->
    @search.q = tag
    @fetch()

  @paginate = (page) ->
    @loadingNextPage = @searchMedia(page).then (response) =>
      @medias = (@medias || []).concat response.medias
      @next_page = response.next_page

  @clearSearch = ->
    @search.q = ""
    @fetch()

  @format_media_url = (media) ->
    return media.filename if media.type == "file"

    parser = document.createElement('a')
    parser.href = media.url
    parser.hostname


  @searchMedia = (page) ->
    Media.search(q: @search.q, page: page, per_page: @perPage)


  @

MediaSearcher.$inject = ['Media']

DunnoApp.service 'MediaSearcher', MediaSearcher
DunnoAppStudent.service 'MediaSearcher', MediaSearcher
