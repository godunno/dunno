core = angular.module('app.core')

core.factory 'UserComment', ['RailsResource', 'railsSerializer',
(RailsResource, railsSerializer) ->
  class UserComment extends RailsResource
    @configure(
      url: '/api/v1/comments'
      name: 'comment'
      updateMethod: 'patch'
    )

    block: ->
      @$patch(@$url('/block'))

    unblock: ->
      @$patch(@$url('/unblock'))

    restore: ->
      @$patch(@$url('/restore'))
]
