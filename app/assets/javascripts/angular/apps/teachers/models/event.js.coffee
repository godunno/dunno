DunnoApp = angular.module('DunnoApp')
DunnoApp.factory 'Event', ['RailsResource', 'railsSerializer', (RailsResource, railsSerializer)->
  class Event extends RailsResource
    @configure(
      url: '/api/v1/events'
      name: 'event'
      idAttribute: 'uuid'
      updateMethod: 'patch'
      serializer: railsSerializer ->
        @resource('topics', 'Topic')
    )

    topics: []
    personal_notes: []

    planned: -> @topics.length > 0
]
