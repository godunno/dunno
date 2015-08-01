DunnoApp = angular.module('DunnoApp')
DunnoApp.factory 'WeeklySchedule', ['RailsResource', (RailsResource)->
  class WeeklySchedule extends RailsResource
    @configure(
      url: '/api/v1/weekly_schedules'
      name: 'weekly_schedule'
      idAttribute: 'uuid'
      updateMethod: 'patch'
    )

    transfer: ->
      @$patch(@$url("transfer"))
]

