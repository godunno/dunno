core = angular.module('app.core')

core.factory 'Topic', ['RailsResource', (RailsResource)->
  class Topic extends RailsResource
    @configure(
      url: '/api/v1/topics'
      name: 'topic'
      idAttribute: 'uuid'
      updateMethod: 'patch'
    )

    transfer: ->
      @$patch(@$url("transfer"))
]

