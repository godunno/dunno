DunnoApp = angular.module('DunnoApp')
DunnoApp.factory 'Media', ['RailsResource', (RailsResource)->
  class Media extends RailsResource
    @configure(
      url: '/api/v1/teacher/medias'
      name: 'media'
      idAttribute: 'uuid'
      updateMethod: 'patch'
    )
]

