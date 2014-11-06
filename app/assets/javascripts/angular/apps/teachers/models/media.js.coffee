DunnoApp = angular.module('DunnoApp')
DunnoApp.factory 'Media', ['RailsResource', '$upload', (RailsResource, $upload)->
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
]

