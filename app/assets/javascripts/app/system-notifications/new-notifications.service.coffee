NewNotifications = ($rootScope, $http) ->
  count = 0

  setCount = (response) ->
    count = response.data.new_notifications_count

  getCount = -> count

  $rootScope.$on '$stateChangeStart', ->
    $http.get('/api/v1/system_notifications/new_notifications.json').then(setCount)

  getCount: getCount

NewNotifications.$inject = ['$rootScope', '$http']

angular
  .module('app.system-notifications')
  .factory('NewNotifications', NewNotifications)
