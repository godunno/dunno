core = angular.module('app.core')

core.factory 'Course', ['RailsResource', 'railsSerializer', (RailsResource, railsSerializer) ->
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

    block: (studentId) ->
      @student_id = studentId
      @$patch(@$url('/block'))

    unblock: (studentId) ->
      @student_id = studentId
      @$patch(@$url('/unblock'))

    promoteToModerator: (studentId) ->
      @student_id = studentId
      @$patch(@$url('/promote_to_moderator'))

    downgradeFromModerator: (studentId) ->
      @student_id = studentId
      @$patch(@$url('/downgrade_from_moderator'))
]
