DunnoApp = angular.module('DunnoApp')

DunnoApp.factory 'Notification', ['RailsResource', (RailsResource)->
  class Notification extends RailsResource
    @configure(
      url: '/api/v1/teacher/notifications'
      name: 'notification'
    )
]

