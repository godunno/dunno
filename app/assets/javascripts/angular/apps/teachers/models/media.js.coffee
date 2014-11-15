DunnoApp = angular.module('DunnoApp')
Media = (RailsResource, $upload)->
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

    update_tag_list: -> @tag_list = @tags.map((tag)-> tag.text)

  Media.interceptAfterResponse (response)->
    medias = if angular.isArray(response) then response else [response]
    for media in medias
      media.tags = (media.tag_list || []).map (tag)-> { text: tag }
    medias

  Media

Media.$inject = ['RailsResource', '$upload']
DunnoApp.factory 'Media', Media
