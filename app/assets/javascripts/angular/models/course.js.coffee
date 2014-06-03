DunnoApp = angular.module('DunnoApp')
DunnoApp.factory 'Course', ($resource)->
  Course = $resource('/api/v1/teacher/courses/:id.json', {id: '@uuid'}, {update: {method: 'PATCH'}})
  Course
