DunnoApp = angular.module('DunnoApp')

TimeGetterSetter = ($filter) ->
  @generate = (object, attribute) ->
    templateDate = new Date()
    templateDate.setSeconds 0

    getTime = ->
      return templateDate unless object[attribute]?.length
      [hours, minutes] = object[attribute].split ':'
      templateDate.setHours hours
      templateDate.setMinutes minutes
      templateDate

    setTime = (time) ->
      return if time.constructor == String
      object[attribute] = $filter('date')(time, 'HH:mm')

    getterSetter = (time) ->
      if time? then setTime(time) else getTime()

  @

TimeGetterSetter.$inject = ['$filter']
DunnoApp.service "TimeGetterSetter", TimeGetterSetter
