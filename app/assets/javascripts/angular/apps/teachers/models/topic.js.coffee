DunnoApp = angular.module('DunnoApp')
DunnoApp.factory 'Topic', ['RailsResource', (RailsResource)->
  class Topic extends RailsResource
    @configure(
      url: '/api/v1/teacher/topics'
      name: 'topic'
      idAttribute: 'uuid'
      updateMethod: 'patch'
    )

    transfer: ->
      @$patch(@$url("transfer"))
]

