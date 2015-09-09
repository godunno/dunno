core = angular.module('app.core')

core.factory 'WeeklySchedule', ['$q', 'RailsResource', ($q, RailsResource)->
  class WeeklySchedule extends RailsResource
    @configure(
      url: '/api/v1/weekly_schedules'
      name: 'weekly_schedule'
      idAttribute: 'uuid'
      updateMethod: 'patch'
    )

    transfer: ->
      deferred = $q.defer()
      WeeklySchedule.configure(fullResponse: true)
      success = (response) ->
        deferred.resolve response.originalData.affected_events

      failure = ->
        deferred.reject(arguments...)

      @$patch(@$url("transfer")).then(success, failure)
      .finally ->
        WeeklySchedule.configure(fullResponse: false)

      deferred.promise
]

