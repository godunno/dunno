Attachment = (RailsResource) ->
  class Attachment extends RailsResource
    @configure(
      url: '/api/v1/attachments'
      name: 'attachment'
      updateMethod: 'patch'
    )

Attachment.$inject = ['RailsResource']

angular
  .module('app.core')
  .factory('Attachment', Attachment)
