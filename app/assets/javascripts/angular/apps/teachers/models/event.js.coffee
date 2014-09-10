DunnoApp = angular.module('DunnoApp')
DunnoApp.factory 'Event', ['RailsResource', (RailsResource)->
  class Event extends RailsResource
    @configure(
      url: '/api/v1/teacher/events'
      name: 'event'
      idAttribute: 'uuid'
      updateMethod: 'patch'
    )

    topics: []
    personal_notes: []
]

