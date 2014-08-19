DunnoApp = angular.module('DunnoAppStudent')

DunnoApp.factory 'Course', ['RailsResource', (RailsResource)->
  class Course extends RailsResource
    @configure(
      url: '/api/v1/courses'
      name: 'course'
      idAttribute: 'access_code'
    )

    #Course.prototype.register = ->
    register: ->
      this.$post(Course.resourceUrl(this) + '/register')
]

