DunnoApp = angular.module('DunnoApp')

DateUtils = ($filter)->
  @asDate = (value)->
    new Date(value)

  @isToday = (value)->
    format = 'YYYY-MM-DD'
    targetDate = $filter('amDateFormat')(@asDate(value), format)
    todayDate  = $filter('amDateFormat')(new Date(), format)
    targetDate == todayDate

  @formattedDate = (date, format)->
    $filter('amDateFormat')(date, format)

  @locationInTime = (date)->
    if @isToday(date)
      'today'
    else if @asDate(date) < new Date()
      'past'
    else
      'future'

  @

DateUtils.$inject = ['$filter']
DunnoApp.service 'DateUtils', DateUtils
