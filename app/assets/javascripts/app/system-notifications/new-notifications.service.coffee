NewNotifications = ($rootScope, SystemNotification) ->
  count = 0

  setCount = (newNotificationsCount) ->
    count = newNotificationsCount

  getCount = -> count

  checkNewNotifications = ->
    SystemNotification.newNotifications().then(setCount)

  $rootScope.$on 'checkNewNotifications', checkNewNotifications
  $rootScope.$on '$stateChangeStart', checkNewNotifications

  getCount: getCount

NewNotifications.$inject = ['$rootScope', 'SystemNotification']

angular
  .module('app.system-notifications')
  .factory('NewNotifications', NewNotifications)
