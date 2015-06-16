DunnoApp = angular.module('DunnoApp')

DunnoApp.factory 'Course', ['RailsResource', (RailsResource)->
  class Course extends RailsResource
    @configure(
      url: '/api/v1/courses'
      name: 'course'
      idAttribute: 'uuid'
      updateMethod: 'patch'
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

