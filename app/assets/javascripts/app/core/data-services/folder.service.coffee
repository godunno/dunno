Folder = (RailsResource) ->
  class Folder extends RailsResource
    @configure(
      url: '/api/v1/folders'
      name: 'folder'
      updateMethod: 'patch'
    )

Folder.$inject = ['RailsResource']

angular
  .module('app.core')
  .factory('Folder', Folder)
