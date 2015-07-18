DunnoApp = angular.module('DunnoApp')
DunnoApp.factory 'Event', ['RailsResource', 'railsSerializer', (RailsResource, railsSerializer)->
  # TODO: Find a way to include the course's uuid on the default parameters
  class Event extends RailsResource
    @configure(
      url: '/api/v1/events'
      name: 'event'
      idAttribute: 'start_at'
      updateMethod: 'patch'
      serializer: railsSerializer ->
        @resource('topics', 'Topic')
    )

    topics: []
    personal_notes: []

    planned: -> @topics.length > 0
]
