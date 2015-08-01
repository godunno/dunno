DunnoApp = angular.module('DunnoApp')

DunnoApp.factory 'Course', ['RailsResource', 'railsSerializer', (RailsResource, railsSerializer)->
  class Course extends RailsResource
    @configure(
      url: '/api/v1/courses'
      name: 'course'
      idAttribute: 'uuid'
      updateMethod: 'patch'
      serializer: railsSerializer ->
        @resource('weekly_schedules', 'WeeklySchedule')
    )

    @search: (identifier) ->
      new Course(uuid: identifier).search()

    search: ->
      Course.$get(@$url('search'))

    register: ->
      @$post(@$url('/register'))

    unregister: ->
      @$delete(@$url('/unregister'))
]

