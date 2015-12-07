Topic = (RailsResource, railsSerializer)->
  class Topic extends RailsResource
    @configure(
      url: '/api/v1/topics'
      name: 'topic'
      idAttribute: 'uuid'
      updateMethod: 'patch'
      serializer: railsSerializer ->
        @resource('media', 'Media')
    )

    transfer: ->
      @$patch(@$url("transfer"))

Topic.$inject = ['RailsResource', 'railsSerializer']
angular
  .module('app.core')
  .factory('Topic', Topic)
