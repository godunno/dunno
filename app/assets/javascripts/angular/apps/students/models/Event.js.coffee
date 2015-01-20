DunnoAppStudent = angular.module('DunnoAppStudent')
DunnoAppStudent.factory 'Event', ['RailsResource', (RailsResource)->
  class Event extends RailsResource
    @configure(
      url: '/api/v1/events'
      name: 'event'
      idAttribute: 'uuid'
      updateMethod: 'patch'
    )

    topics: []
    personal_notes: []

    planned: -> @topics.length > 0
]

