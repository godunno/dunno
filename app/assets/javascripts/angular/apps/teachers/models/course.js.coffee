DunnoApp = angular.module('DunnoApp')

DunnoApp.factory 'Course', ['RailsResource', (RailsResource)->
  class Course extends RailsResource
    @configure(
      url: '/api/v1/teacher/courses'
      name: 'course'
      idAttribute: 'uuid'
      updateMethod: 'patch'
    )
]

