DunnoApp = angular.module('DunnoAppStudent')

DunnoApp.factory 'Course', ['RailsResource', (RailsResource)->
  class Course extends RailsResource
    @configure(
      url: '/api/v1/courses'
      name: 'course'
      idAttribute: 'access_code'
    )

    register: ->
      this.$post(Course.resourceUrl(this) + '/register')
    unregister: ->
      this.$delete(Course.resourceUrl(this) + '/unregister')
]

