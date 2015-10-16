NewNotifications = ($rootScope, SystemNotification) ->
  count = 0

  setCount = (newNotificationsCount) ->
    count = newNotificationsCount

  getCount = -> count

  $rootScope.$on '$stateChangeStart', ->
    SystemNotification.newNotifications().then(setCount)

  getCount: getCount

NewNotifications.$inject = ['$rootScope', 'SystemNotification']

angular
  .module('app.system-notifications')
  .factory('NewNotifications', NewNotifications)
