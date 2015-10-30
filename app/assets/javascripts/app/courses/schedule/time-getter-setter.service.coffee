TimeGetterSetter = ($filter) ->
  @generate = (object, attribute) ->
    templateDate = new Date()
    templateDate.setSeconds 0

    getTime = ->
      return templateDate unless object[attribute]?
      return undefined unless object[attribute].length
      [hours, minutes] = object[attribute].split ':'
      templateDate.setHours hours
      templateDate.setMinutes minutes
      templateDate

    setTime = (time) ->
      object[attribute] = $filter('date')(time, 'HH:mm')

    setTime(getTime())

    getterSetter = (time) ->
      if time? then setTime(time) else getTime()

  @

TimeGetterSetter.$inject = ['$filter']

angular
  .module('app.courses')
  .service('TimeGetterSetter', TimeGetterSetter)
