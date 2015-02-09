DunnoApp = angular.module('DunnoApp')
Media = (RailsResource, $upload, $q) ->
  class Media extends RailsResource
    @configure(
      url: '/api/v1/teacher/medias'
      name: 'media'
      idAttribute: 'uuid'
      updateMethod: 'patch'
    )

    preview: ->
      Media.$get("#{@$url()}/preview", url: @url)

    upload: ->
      $upload.upload
        url: @$url() + ".json"
        file: @file

    update_tag_list: ->
      @tag_list = @tags.map (tag) -> tag.text

    @search: (options) ->
      deferred = $q.defer()
      Media.configure(fullResponse: true)
      @query(options).then((response) ->
        Media.configure(fullResponse: false)
        deferred.resolve(
          medias: response.data
          previous_page: response.originalData.previous_page
          current_page: response.originalData.current_page
          next_page: response.originalData.next_page
        )
      , ->
        deferred.reject(arguments...)
      )
      deferred.promise

  Media.interceptAfterResponse (response)->
    medias = if response.data? then response.data else [response]
    for media in medias
      media.tags = (media.tag_list || []).map (tag) -> { text: tag }
    response

  Media

DunnoApp.factory 'Media', Media
