core = angular.module('app.core')

core.factory 'Notification', ['RailsResource', (RailsResource)->
  class Notification extends RailsResource
    @configure(
      url: '/api/v1/notifications'
      name: 'notification'
    )
]

