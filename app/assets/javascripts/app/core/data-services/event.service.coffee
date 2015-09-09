Event = (RailsResource, $q, railsSerializer) ->
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

    # TODO: Extract this configuration
    @paginate: (options) ->
      deferred = $q.defer()
      Event.configure(fullResponse: true)

      success = (response) ->
        deferred.resolve
          events: response.data
          finished: response.originalData.finished

      failure = ->
        deferred.reject(arguments...)

      @query(options).then(success, failure)
      .finally ->
        Event.configure(fullResponse: false)

      deferred.promise

  Event.interceptBeforeRequest (request, klass, event) ->
    return request unless event?
    request.params ?= {}
    request.params.course_id ?= event.course.uuid
    request

  Event

Event.$inject = ['RailsResource', '$q', 'railsSerializer']

angular
  .module('app.core')
  .factory('Event', Event)
