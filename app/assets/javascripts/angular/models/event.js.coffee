DunnoApp = angular.module('DunnoApp')
DunnoApp.factory 'Event', ($resource)->
  Event = $resource('/api/v1/teacher/events/:id.json', {id: '@uuid'}, {update: {method: 'PATCH'}})
  Event
