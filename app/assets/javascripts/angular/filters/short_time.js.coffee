DunnoApp = angular.module('DunnoApp')

DunnoApp.filter 'shortTime', ()->
  (time)->
    output = ''

    [hours, minutes] = time.split ':'
    if hours.length <= 1
      hours = "0#{hours}"
    output += hours

    if minutes != "00"
      output += ":#{minutes}"

    output

