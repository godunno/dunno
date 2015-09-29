Event = (RailsResource, $q, railsSerializer) ->
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

    @paginate: (options) ->
      deferred = $q.defer()
      Event.configure(fullResponse: true)

      success = (response) ->
        deferred.resolve
          events: response.data
          previousMonth: response.originalData.previous_month
          currentMonth: response.originalData.current_month
          nextMonth: response.originalData.next_month

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
