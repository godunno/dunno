DunnoApp = angular.module('DunnoApp')
DunnoApp.factory 'PersonalNote', ['RailsResource', (RailsResource)->
  class PersonalNote extends RailsResource
    @configure(
      url: '/api/v1/teacher/personal_notes'
      name: 'personal_notes'
      idAttribute: 'uuid'
      updateMethod: 'patch'
    )

    transfer: ->
      @$patch(@$url("transfer"))
]

